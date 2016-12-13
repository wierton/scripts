#!/usr/bin/python
#coding=utf-8

from Crypto.PublicKey import RSA
import urllib2
import urllib
import re

key = RSA.importKey('''-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAqEsPBgxV7vxFL9lVy4RuOIr+SJcXXzbnnLo1YUnlMePeob5y
ApOeNM6Cmh8hOi+ZoTMQH4qQ5s+5TEh2L20ZxRCyD3aQHuriNVFZIovlQrmsQWHI
+GaLb1YJqIb91q8uKdvzCBTeg/l09peIXnvwdxC8i3DbKE2HKUHO2/DSIbdb78NQ
z6ETzWPuT5eRUaKL1BzZwkl+5LsMJrdWip5gjQ+YOe5cAQGtlKBS918TcWgJkXUW
NzJ/xF6Uc7gRuFIJ4nP/AzQiqs9sPx+8LeF46+uq2EvNOvItlH2Ns3mt5vFHgRYZ
6rUZbd/M6jFYCxN1uaEUNoAEXeo/ggUL9Z8tDwIDAQABAoIBAFBt9tMkKBmcNRCm
JMusEeUyAE7+7quRmOWdVI+XelL6nVbdpq02kYCZRW+U+xNM1nZk6gq49YFpuxwK
8Xi/AnbdAMxFFKHCDbP/mcLZ6wqVpA5nRl343CCslNcXFM96T2yv8pllJ+cY3F5R
k1ncj9LHi+R0XjkHvFXqXotcr4Bu07BI8CfqP8x+BTJT7aB0CfPpp3gqOMTo6wy/
aI+uuNMV3E23kdfier6c5A/f/M/M0J4r2ygzp5ii8PBxBdJ32ry61U87sHYTWc4x
Oa7XM9PifbjcU1WIjpA1rxGSsnX4Aw8H2nPzsMXHrmZVVE5LpaHZAfRAAn0+pRpZ
tunl9ZECgYEAy3rvu6Nq4Bl2s3dcG35KOeu5+oOWqxbpIyfhGLcoflZepqReb8s3
0kRLvzXi6u2koKp44LbZfbC+MvfLv1V/dYAQHHw9IgKyecr5vU+PMcE9bZDG4/P6
VP+ciI4OtwsVfEJwLvtU/LWo6ED2wjcT/crcHtB7QXQ74SwrJbczuNkCgYEA07se
/LcEjPu7U1AkxWxpW7VF1j9YxeZgIM5uGe+M3Pnd+eI64bpiJ74mzOodXYmYEiId
t6V7KqF/GiB8voIhJBW156jaFmRKnwXnqoBzU20YZisM/TSHn8Dsb6TTwWx1gurt
qxX4HZ98cIAJd0VOe0vNYxNegf07GpxAGyELpCcCgYAr57nkte0wr63iKYYRVJ21
g7ycZlpTTl09vbQfPh4ZrI89y8eovaOs1hm2B22QHXjhRgdRDYM+UK2pl7g577vR
4bEYRGJ4fTZ/eyGKDKmsJbMYeh3AP/uq7YCcInLgYh7fsgI80PRUlun8O1BDNdk1
cNkwOPHvfKITAxHIUJBzeQKBgGdZsXh+BZSj0/6I4koT7yG6zEoWRcjj+QxKd2fl
jIbY2Md+7Gr+xabMpLfll0vvO/GuAX+BISvgBODF9t4vOuoYRuC7hSjk75/MDBcn
+CNC32QPo5l9KK6MR1z/wfVqcbnj3vtiD+i1ztJDTVuQ0wxQJgM0ky80YsNMfeZA
LSSFAoGBALfuvDs5Bck0fqwdKR0qaIQ9OKl6FoUGfpkXuxdTCsjXl0sAC1ei5e+y
5Fhuq1Fh6tDwYjtewPUMnMu6AbhAckqGuvv3bI42ZqfxlJwYV6GT45dU8g9l5y/l
a7RQfd6zRRyrsUzjHj7V9n0S7+yuQskOymtlc7HsRC1CO2rT/AuH
-----END RSA PRIVATE KEY-----
''')

def parse_args():
    import getopt, sys
    passwd_updated = False;
    opts, args = getopt.getopt(sys.argv[1:], "u:p:", ['username=', 'password=', 'logout'])
    global username, password, request_url
    for opt,arg in opts:
        if opt in ('-u', '--username'):
            username = arg
        elif opt in ('-p', '--password'):
            password = arg
            passwd_updated = True
        elif opt == '--logout':
            request_url = 'http://p.nju.edu.cn/portal_io/logout'
    if not passwd_updated:
        password = key.decrypt(password)
    elif not password:
        sys.stderr.write('password not specified!\n')
        exit(0)

try:
    username = '141242068'
    password = 'R\xc6\x86\x81\x0b\xe6J\tX\x0e\xc6f\x11iS]\x9f\xd3\xeb\x11\xa2\x89\x1d\xa7\xa6Y\x17\xf78\xc0\xcd\xf5]4p\x16\x91\x8a\x15\x99\xb22\x98\x08+\xd1\rU\x83h\n\xf2\xc1\xf6b \x8e\xc6\xee3\x9aYdN\xe1@\xd3\x95\x0f\x802~\xb5\xf7Wwz\x83kY\xc6lJ\xe7\xdb\xee-I@*\xfa\xd0\x99V\rh\xe6l\x8fb\xc1\x1d\xf1\x00*\xe9\\\xa35\xb9\xa3\xee\x82.\x03\x81\x12\xa1kfL@\xfa\xf5;\x00\xfe\x10`\n\x18\xcaX\xc6#\xf9\x14\xee\x80\x93\xce\x85,\x9c\xbf\xdd\x18@\x9a\xe6\x07\xce~O\xfc\x11\xd5\xb6\xa4\xc8v\xf9\x0f\xc4$\x1a\x8dw\xff\xad\xecGL\x07Ej\x0e\x97\xdd\xbb\xca\xfaZ\xa3\xf2\xf3\xf7\xfdfnh\xe4\x14\xcb\x87\x8f\xb3@\x8ba\x11\x19\x03\xef\xf6\x96\xe9\xff\xda+7\x1dr\xbeu\xfa\xd4kZ\x85\xa7\xaa,\x16\xb1\xcdF\xbb\xe8(-\xef/\x1f\xbbG\xcb\x0bY\xba\x984x\xee\xac#\xb3;C\x9b\xb6\xe8\xf2\xe8\xe4\xb5'
    request_url = 'http://p.nju.edu.cn/portal_io/login'
    parse_args()
    request_rawdata = {'username':username, 'password':password}
    request_data = urllib.urlencode(request_rawdata)
    request = urllib2.Request(request_url, request_data)
    response = urllib2.urlopen(request)
    print response.read()
except urllib2.URLError as e:
    if hasattr(e, 'reason'):
        print e.reason
