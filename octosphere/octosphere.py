"""Octosphere -- an IRC bot framework

Dependencies:
  * cypy >= 1.0
"""
import asyncore
from cypy import irclib

class CommandProcessor(object):
  """

  Define commands to handle by implementing methods of the form:

  handle_<command_string>(self, bot, sender, message)

  If the function returns True, no further processors attempt to parse the
  command.

  """
  def __init__(self):
    self._prefix = ''
    self._commands = {}
    for attr_name in dir(self):
      if attr_name.startswith('handle_'):
        self._commands[attr_name[len('handle_'):]] = getattr(self, attr_name)

  def default_handler(self, bot):
    pass

  def handle(self, bot, sender, message):
    if message.startswith(self._prefix):
      message = message[len(self._prefix):]
    
    if not message:
      self.default_handler(bot)
      return True

    command, rest = (message.split(' ', 1) + [''])[:2]
    if command in self._commands:
      return self._commands[command](bot, sender, rest)
    return False

class DefaultProcessor(CommandProcessor):
  def handle_joinchannel(self, bot, sender, message):
    channel, password = (message.split(None, 1) + [''])[:2]
    bot.join(channel, password)
    return True

class Octosphere(irclib.IRC):
  def __init__(self, nick='Octosphere', user_name='', real_name=''):
    irclib.IRC.__init__(self, nick, user_name, real_name)
    self.processors = []

  def start(self, host='', port=6667, password=''):
    if host:
      self.connect(host, port, password)
    asyncore.loop()
  
  def on_connect(self):
    self.set_mode(self.nick, '+B')
    pass

  def on_notice(self, target, sender, message):
    print '-- %s:%s: %s' % (sender, target, message)

  def on_message(self, channel, sender, message):
    pass

  def on_private_message(self, sender, message):
    for processor in self.processors:
      if processor.handle(self, sender, message):
        return
