"""Minecraft -- various utilities for interacting with Minecraft

Dependencies:
 * minecraft_server.jar

Cory Petosky, October 2010

"""
import asyncore
import asynchat
import re
import socket
import sys
import thread
import os
from subprocess import Popen, PIPE, STDOUT
from Queue import Queue, Empty

class Channel(asynchat.async_chat):
  def __init__(self, server, socket, address):
    asynchat.async_chat.__init__(self, socket)
    self.server = server
    self.socket = socket
    self.set_terminator("\n")
    self.data = ''
    self.authed = False
  
  def handle_close(self):
    self.server.channels.remove(self)
    asynchat.async_chat.handle_close(self)

  def collect_incoming_data(self, data):
    self.data += data

  def found_terminator(self):
    message = self.data
    self.data = ''
    if self.authed:
      self._handle_message(message)
    else:
      self._handle_auth(message)

  def _handle_message(self, message):
    self.server.send_command(message)

  def _handle_auth(self, message):
    if message != self.server.secret:
      print 'auth fail, killing client'
      self.close_when_done()
    else:
      print 'auth success'
      self.authed = True

class Server(asyncore.dispatcher):
  """A wrapper for the Minecraft Server.

  Opens a port on """
  def __init__(self, path='', port=25564, secret='seekrit'):
    asyncore.dispatcher.__init__(self)
    self.secret = secret
    self.port = port
    if path[-4:] != '.jar':
      path = os.path.join(path, 'minecraft_server.jar')
    self.path = path
    self.channels = []

  def handle_accept(self):
    conn, address = self.accept()
    self.channels.append(Channel(self, conn, address))

  def start(self):
    # Start handling socket connections
    self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
    self.bind(('', self.port))
    self.listen(5)
    
    # Start up the Minecraft server
    cmd = 'java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui'
    self.process = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT)
    self._output = Queue()
    thread.start_new(self._process_output, ())

    # Process connections
    while True:
      try:
        line = self._output.get_nowait()
        for channel in self.channels:
          channel.push('%s' % line)
      except Empty:
        pass  
      asyncore.loop(timeout=0.1, count=1)

  def _process_output(self):
    """Processes the Minecraft server's output."""
    while True:
      line = self.process.stdout.readline()
      self._output.put(line)

  def send_command(self, command):
    if command[-1:] != '\n':
      command += '\n'
    print 'processing: %s' % command
    self.process.stdin.write(command)

class AdminClient(asynchat.async_chat):
  """An admin console that can connect to a cypy.minecraft.Server instance."""

  def __init__(self):
    asynchat.async_chat.__init__(self)
    self.set_terminator('\n')
    self.data = ''
    self.users = set()
    self._output = Queue()

  def collect_incoming_data(self, data):
    """Collect incoming data into a buffer for later processing."""
    self.data += data

  def found_terminator(self):
    """Process the complete message stored on the buffer."""
    message = self.data
    self.data = ''
    self._process_output_line(message)

  def connect(self, password, host='localhost', port=25564):
    self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
    asynchat.async_chat.connect(self, (host, port))
    self.send_command(password)

    # immediately get player list, so our internal list is up-to-date
    self.send_command('list')
  
  def run(self):
    asyncore.loop()

  def run_async(self):
    thread.start_new(self.run, ())

  def send_command(self, command):
    if command[-1:] != '\n':
      command += '\n'
    self.push(command)

  def get_output_line(self):
    try:
      return self._output.get(True, 2)
    except Empty:
      return None

  def has_output(self):
    return self._output.empty()

  def clear_output(self):
    try:
      while True:
        self._output.get_nowait()
    except Empty:
      pass

  __logged_in_regex = re.compile(
      r'^(?P<user>[A-Za-z0-9_-]+) \[.*\] logged in$')
  __logged_out_regex = re.compile(
      r'^(?P<user>[A-Za-z0-9_-]+) lost connection:')
  __list_regex = re.compile(
      r'^Connected players: (?P<users>([A-Za-z0-9_-]+(, )?)*)$')
  __command_regex = re.compile(
      r'^(?P<user>[A-Za-z0-9_-]+) tried command: (?P<command>[A-Za-z0-9_ -]+)$')
  
  def _process_output_line(self, line):
    sentinel = '[INFO] '
    if sentinel in line:
      line = line[line.find(sentinel) + len(sentinel):]

    # Handle logged in
    match = AdminClient.__logged_in_regex.match(line)
    if match:
      user = match.group('user')
      if len(self.users) == 0:
        other_users = "None"
      else:
        other_users = ', '.join(self.users)
      self.users.add(user)
      self.on_logged_in(user)
      return
    
    # Handle logged out
    match = AdminClient.__logged_out_regex.match(line)
    if match:
      user = match.group('user')
      self.users.discard(user)
      self.on_logged_out(user)
      return

    # Handle list
    match = AdminClient.__list_regex.match(line)
    if match:
      users = match.group('users')
      users = users.split(',')
      self.users = set(user.strip() for user in users)
      return

    # Handle command
    match = AdminClient.__command_regex.match(line)
    if match:
      user = match.group('user')
      command = match.group('command')
      command = command.split()
      command, args = command[0], command[1:]
      self.on_user_command(user, command, args)
      return
    
    # Doesn't match anything we understand, queue it for other processors
    self.on_unknown_line(line)
    self._output.put(line)

  def on_logged_in(self, user):
    pass

  def on_logged_out(self, user):
    pass

  def on_user_command(self, user, command, args):
    pass
  
  def on_unknown_line(self, line):
    pass

if __name__ == '__main__':
  args = sys.argv[1:]
  if args[0] == 'server':
    secret = args[1]
    server = Server(secret=secret)
    server.start()
