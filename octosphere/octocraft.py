"""Octocraft -- an Octosphere-based Minecraft server wrapper.

Octocraft will spin up the Minecraft server, an IRC bot that can accept op
commands, and a simple webserver that lets people know some basic server stats.

Dependencies:
  * Python >= 2.7 (2.6 will probably work too, but haven't tested it)
  * CherryPy >= 3.1.2
  * octosphere >= 1.0
  * cypy.minecraft >= 1.0

Cory Petosky, October 2010
"""
import cherrypy
import sys
import thread
import time
from cypy.minecraft import AdminClient
from octosphere import Octosphere, CommandProcessor, DefaultProcessor

class MinecraftProcessor(CommandProcessor):
  def __init__(self, secret):
    CommandProcessor.__init__(self)
    self.secret = secret
    self.ops = []
    self._prefix = 'minecraft'

  def handle_list(self, bot, sender, message):
    users = ', '.join(bot.server.users) if bot.server.users else 'None'
    bot.send_message(sender, 'Connected players: %s' % users)
    return True

  def handle_raw(self, bot, sender, message):
    if sender in self.ops:
      bot.server.send_command(message)
    else:
      bot.send_message(sender, 'Must auth first.')

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

class MinecraftWebserver(object):
  def __init__(self, client):
    self.game_client = client

  @cherrypy.expose
  def index(self):
    return ('Minecraft server is up!\n'
            'Players online: %s' % ', '.join(self.game_client.users))

if __name__ == '__main__':
  args = sys.argv[1:]
  secret = args[0]
  client = AdminClient()
  client.connect(secret)
  bot = Octosphere()
  bot.processors += [DefaultProcessor(), MinecraftProcessor(secret)]
  bot.server = client
  thread.start_new(bot.start, ('irc.synirc.net',))
  cherrypy.config.update('webserver.properties')
  cherrypy.quickstart(MinecraftWebserver(client))
