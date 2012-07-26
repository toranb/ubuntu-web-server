def application(environ, start_response):
    start_response('200 OK', [('Content-Type','text/plain')])
    yield 'hello world\n'
