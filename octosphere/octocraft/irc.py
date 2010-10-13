from cypy import minecraft
import octosphere
import sys

class MinecraftProcessor(octosphere.CommandProcessor):
  def __init__(self, secret):
    octosphere.CommandProcessor.__init__(self)
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


if __name__ == '__main__':
  args = sys.argv[1:]
  secret = args[0]
  if len(args) > 1:
    host = args[1]
  else:
    host = 'localhost'
  if len(args) > 2:
    irchost = args[2]
  else:
    irchost = 'irc.synirc.net'
  client = minecraft.AdminClient()
  client.connect(secret, host=host)
  bot = octosphere.Octosphere()
  bot.processors += [octosphere.DefaultProcessor(), MinecraftProcessor(secret)]
  bot.server = client
  bot.start(irchost)
