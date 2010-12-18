from cypy import minecraft
import cherrypy
import optparse
import os
import thread

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
    cherrypy.config.update({'tools.staticdir.root': os.getcwd()})
    parser = optparse.OptionParser()
    parser.add_option(
            '-s', '--secret',
            help='shared secret between servers and clients')
    parser.add_option(
            '-n', '--host', default='localhost',
            help='host to connect to')
    parser.add_option(
            '-p', '--port', type='int', default=None,
            help='port to listen/connect on')
    options, args = parser.parse_args()

    client = minecraft.AdminClient()
    def ready_callback():
        thread.start_new(
                cherrypy.quickstart,
                (MinecraftWebserver(client),),
                {'config': 'webserver.properties'})
    
    client.on_ready = ready_callback
    client.connect(secret=options.secret, host=options.host, port=options.port)
