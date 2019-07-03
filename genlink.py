#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import time


def parsemeta(url):
  info = {'url': url}
  with open(url, 'r', encoding='utf-8') as f:
    for line in f:
      if line.startswith('#+TITLE:'):
        info['title'] = line.replace('#+TITLE:', '').strip()
      if line.startswith('#+DATE:'):
        str = line.replace('#+DATE:', '').strip()
        info['date'] = time.strptime(str, '<%Y-%m-%d %a>')
    return info


def getinfos(dir):
  infos = []
  for root, dirs, files in os.walk(dir):
    for file in files:
      if file.endswith('.org'):
        url = os.path.join(root, file)
        infos.append(parsemeta(url))
    return infos


def infos2text(infos):
  infos.sort(key=lambda x: -time.mktime(x['date']))
  titles = []
  for index, info in enumerate(infos, start=1):
    titles.append('{index:02d}. [[./{path}][{title}]] {date}'.format(
        index=index,
        path=info['url'].replace('\\', '/'),
        title=info['title'],
        date=time.strftime('%Y-%m-%d', info['date'])
    ))
  return '\n'.join(titles)


if __name__ == '__main__':
  content = '* Index'
  content += '\n** Articles\n'
  content += infos2text(getinfos('article'))
  content += '\n** Programming Language\n'
  content += infos2text(getinfos('lang'))
  content += '\n** Misc.\n'
  content += infos2text(getinfos('misc'))
  content += '\n'
  sys.stdout.buffer.write(content.encode("utf8"))
