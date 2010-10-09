from cypy import minecraft
import cherrypy
import sys

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
  client = minecraft.AdminClient()
  client.connect(secret)
  client.run_async()
  cherrypy.config.update('webserver.properties')
  cherrypy.quickstart(MinecraftWebserver(client))
