from cypy import minecraft
import cherrypy
import os
import sys

class MinecraftWebserver(object):
  def __init__(self, client):
    self.game_client = client

  @cherrypy.expose
  def index(self):
    return ('Minecraft server is up!\n'
            'Players online: %s' % ', '.join(self.game_client.users))

  @cherrypy.expose
  def backups(self):
    template = """
<html>
<head><title>Minecraft backups</title></head>
<body>
  <h2>Minecraft backups</h2>
  <ul>
  %s
  </ul>
</body>
</html>"""
    line_template = """<li><a href="%(name)s">%(name)s</a></li>"""
    body = []
    for filename in os.listdir('backups'):
      body.append(line_template % {'name': 'backups/%s' % filename})
    return template % '\n'.join(body)

if __name__ == '__main__':
  args = sys.argv[1:]
  secret = args[0]
  client = minecraft.AdminClient()
  client.connect(secret)
  client.run_async()
  cherrypy.config.update({'tools.staticdir.root': os.getcwd()})
  cherrypy.quickstart(MinecraftWebserver(client), config='webserver.properties')
