"""Minecraft -- various utilities for interacting with Minecraft

Dependencies:
 * minecraft_server.jar
 * twisted

Cory Petosky, October 2010

"""
import re
import thread
import optparse
import os
from subprocess import Popen, PIPE, STDOUT
from Queue import Queue, Empty

from twisted.internet import endpoints
from twisted.internet import protocol
from twisted.internet import reactor
from twisted.protocols import basic

DEFAULT_PORT = 25564

class Channel(basic.LineReceiver):
  delimiter = '\n'

  def connectionMade(self):
    self.factory.channels.append(self)
    self.authed = not bool(self.factory.secret)
  
  def connectionLost(self, reason):
    self.factory.channels.remove(self)

  def lineReceived(self, line):
    if self.authed:
      self._handle_message(line)
    else:
      self._handle_auth(line)

  def _handle_message(self, message):
    self.factory.server.send_command(message)

  def _handle_auth(self, message):
    if message != self.factory.secret:
      self.transport.loseConnection()
    else:
      self.authed = True


class Server(object):
  """A wrapper for the Minecraft Server."""
  def __init__(self, port=DEFAULT_PORT, path='', secret=None):
    self.port = port
    self.factory = protocol.Factory()
    self.factory.channels = []
    self.factory.protocol = Channel
    self.factory.secret = secret
    self.factory.server = self

    if path[-4:] != '.jar':
      path = os.path.join(path, 'minecraft_server.jar')
    self.path = path

  def start(self):    
    # Start up the Minecraft server
    cmd = 'java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui'
    self.process = Popen(
        cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    thread.start_new(self._process_output, ())
    reactor.listenTCP(self.port, self.factory)
    reactor.run()

  def _process_output(self):
    """Processes the Minecraft server's output."""
    while True:
      line = self.process.stdout.readline()[:-1]
      for channel in self.factory.channels:
        channel.sendLine(str(line))
        channel.transport.doWrite()

  def send_command(self, command):
    if command[-1] != '\n':
      command += '\n'
    self.process.stdin.write(command)

class ClientChannel(basic.LineReceiver):
  delimiter = '\n'

  __logged_in_regex = re.compile(
      r'^(?P<user>[A-Za-z0-9_-]+) \[.*\] logged in with entity id [0-9]+$')
  __logged_out_regex = re.compile(
      r'^(?P<user>[A-Za-z0-9_-]+) lost connection:')
  __list_regex = re.compile(
      r'^Connected players: (?P<users>([A-Za-z0-9_-]+(, )?)*)$')
  __command_regex = re.compile(
      r'^(?P<user>[A-Za-z0-9_-]+) tried command: (?P<command>[A-Za-z0-9_ -]+)$')
  
  def connectionMade(self):
    self.client = self.factory.client
    if self.client.secret:
      self.send_command(self.client.secret)
    self.send_command('list')
    self.client.protocol = self
    self.client.on_ready()

  def send_command(self, command):
    if len(command) == 0:
      return
    self.sendLine(str(command))
    self.transport.doWrite()

  def lineReceived(self, line):
    sentinel = '[INFO] '
    if sentinel in line:
      line = line[line.find(sentinel) + len(sentinel):]
    print line

    # Handle logged in
    match = self.__logged_in_regex.match(line)
    if match:
      user = match.group('user')
      if len(self.client.users) == 0:
        other_users = "None"
      else:
        other_users = ', '.join(self.users)
      self.client.users.add(user)
      self.client.on_logged_in(user)
      return
    
    # Handle logged out
    match = self.__logged_out_regex.match(line)
    if match:
      user = match.group('user')
      self.client.users.discard(user)
      self.client.on_logged_out(user)
      return

    # Handle list
    match = self.__list_regex.match(line)
    if match:
      users = match.group('users')
      users = users.split(',')
      self.client.users = set(user.strip() for user in users)
      return

    # Handle command
    match = self.__command_regex.match(line)
    if match:
      user = match.group('user')
      command = match.group('command')
      command = command.split()
      command, args = command[0], command[1:]
      self.client.on_user_command(user, command, args)
      return
    
    # Doesn't match anything we understand, queue it for other processors
    self.client.on_unknown_line(line)
    self.client.output.put(line)


class AdminClient(object):
  """An admin console that can connect to a cypy.minecraft.Server instance."""

  def connect(self, secret=None, host=None, port=None):
    if not host:
      host = 'localhost'
    if not port:
      port = DEFAULT_PORT
    self.secret = secret
    self.output = Queue()
    self.users = set()
    factory = protocol.ClientFactory()
    factory.protocol = ClientChannel
    factory.client = self
    reactor.connectTCP(host, port, factory)
    reactor.run()

  def send_command(self, command):
    if self.protocol:
      self.protocol.send_command(command)

  def get_output_line(self):
    try:
      return self.output.get(True, 2)
    except Empty:
      return None

  def has_output(self):
    return self.output.empty()

  def clear_output(self):
    try:
      while True:
        self.output.get_nowait()
    except Empty:
      pass

  def on_ready(self):
    pass

  def on_logged_in(self, user):
    pass

  def on_logged_out(self, user):
    pass

  def on_user_command(self, user, command, args):
    pass
  
  def on_unknown_line(self, line):
    pass


if __name__ == '__main__':
  parser = optparse.OptionParser()
  parser.add_option(
      '-m', '--mode', default='server',
      help='one of "client","server" [default=server]')
  parser.add_option(
      '-s', '--secret',
      help='shared secret between servers and clients')
  parser.add_option(
      '-p', '--port', type='int', default=DEFAULT_PORT,
      help='port to listen/connect on')
  options, args = parser.parse_args()
  if options.mode == 'server':
    server = Server(port=options.port, secret=options.secret)
    server.start()

