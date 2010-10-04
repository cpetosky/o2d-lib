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

    # Start actually processing sockets
    asyncore.loop()

  def _process_output(self):
    """Processes the Minecraft server's output."""
    while True:
      line = self.process.stdout.readline()
      for channel in self.channels:
        channel.push('%s' % line)

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

  __logged_in_regex = re.compile(r'^(?P<user>[A-Za-z0-9_-]+) \[.*\] logged in$')
  __logged_out_regex = re.compile(r'^(?P<user>[A-Za-z0-9_-]+) lost connection:')
  
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
      self.send_command('say Other players online: %s' % other_users)
      self.users.add(user)
      return
    
    # Handle logged out
    match = AdminClient.__logged_out_regex.match(line)
    if match:
      user = match.group('user')
      self.users.discard(user)
      return
    
    # Doesn't match anything we understand, queue it for other processors
    print line
    self._output.put(line)

if __name__ == '__main__':
  args = sys.argv[1:]
  if args[0] == 'server':
    secret = args[1]
    server = Server(secret=secret)
    server.start()
