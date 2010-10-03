"""Octocraft -- an Octosphere-based Minecraft server wrapper.

Octocraft will spin up the Minecraft server, an IRC bot that can accept op
commands, and a simple webserver that lets people know some basic server stats.

Dependencies:
  * Python >= 2.7 (2.6 will probably work too, but haven't tested it)
  * CherryPy >= 3.1.2



Cory Petosky, October 2010
"""
import cherrypy
import thread
from subprocess import Popen, PIPE, STDOUT
from Queue import Queue, Empty
from octosphere import Octosphere, CommandProcessor, DefaultProcessor

class MinecraftProcessor(CommandProcessor):
  def __init__(self, secret):
    CommandProcessor.__init__(self)
    self.secret = secret
    self.ops = []
    self._prefix = 'minecraft'

  def handle_list(self, bot, sender, message):
    bot.server.clear_output()
    bot.server.send('list')
    line = bot.server.get_output_line()
    while line:
      bot.send_message(sender, line)
      line = bot.server.get_output_line()
    return True

  def handle_auth(self, bot, sender, message):
    if sender in self.ops:
      bot.send_message(sender, 'You are already an op.')
      return

    tokens = message.split()
    if len(tokens) != 1:
      bot.send_message(sender, 'Try AUTH <secret>')
      return

    secret = tokens[0]
    if secret != self.secret:
      bot.send_message(sender, 'Incorrect secret.')
      return

    self.ops.append(sender)
    bot.send_message(sender, 'Authed successfully.')
    return True

class MinecraftServer(object):
  def start(self):
    cmd = 'java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui'
    self.process = Popen(cmd, shell=True, stdin=PIPE, stderr=PIPE)
    self._output = Queue()
    self.users = []
    thread.start_new(self._process_output, ())

  def send(self, command):
    self.process.stdin.write('%s\r\n' % command)

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
  
  def _process_output(self):
    """Processes the Minecraft server's output.

    We listen on stderr because currently Minecraft outputs console command
    results to stderr. Similarly, we ignore stdout because only useless
    information is sent there. This will likely change in the future.
    """
    sentinel = '[INFO] '
    while True:
      line = self.process.stderr.readline()
      if sentinel in line:
        line = line[line.find(sentinel) + len(sentinel):]

      # Some commands we can handle directly
      if 'logged in' in line:
        user = line.split()[0]
        if len(self.users) == 0:
          other_users = "None"
        else:
          other_users = ', '.join(self.users)
        self.send('tell %s Other players online: %s' % (user, other_users))
        self.users.append(user)
      elif 'lost connection' in line:
        self.users.remove(line.split()[0])
      else:
        self._output.put(line)

class MinecraftWebserver(object):
  def __init__(self, game_server):
    self.game_server = game_server

  @cherrypy.expose
  def index(self):
    return ('Minecraft server is up!\n'
            'Players online: %s' % ', '.join(self.game_server.users))


if __name__ == '__main__':
  server = MinecraftServer()
  server.start()
  bot = Octosphere()
  bot.processors += [DefaultProcessor(), MinecraftProcessor('seekrit')]
  bot.server = server
  thread.start_new(bot.start, ('irc.synirc.net',))
  cherrypy.config.update('webserver.properties')
  cherrypy.quickstart(MinecraftWebserver(server))
