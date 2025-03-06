# termuxAndroidHelpers

shorthands, scripts for termux on android


provided as is with no waranty, no support

———————————————


"""

import requests

import re

from urllib.parse import unquote


# 定义URL和请求头

url = 'https://c.map987.us.kg/https://app.box.com/index.php?folder_id=307393495021&q%5Bshared_item%5D%5Bshared_name%5D=9kyetxelu85r7o3ipyytadxbygm0r8x9&rm=box_v2_zip_shared_folder'

headers = {

'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0',

'Accept': 'application/json, text/plain, */*',

'Accept-Language': 'en-US,en;q=0.5',

'Accept-Encoding': 'gzip, deflate, br, zstd',

'X-Box-Client-Name': 'enduserapp',

'X-Box-Client-Version': '23.54.1',

'Alt-Used': 'app.box.com',

'Connection': 'keep-alive',

'Referer': 'https://app.box.com/s/9kyetxelu85r7o3ipyytadxbygm0r8x9',

'Cookie': 'z=sjqt3qd249h16eul6l40a80sjm; box_visitor_id=67c859d47d52e2.25286109; bv=MONO-8203; cn=30; site_preference=desktop; anonymousbanner=seen',

'Sec-Fetch-Dest': 'empty',

'Sec-Fetch-Mode': 'cors',

'Sec-Fetch-Site': 'same-origin',

'TE': 'trailers'

}


# 发送请求

response = requests.get(url, headers=headers)


# 检查请求是否成功

if response.status_code == 200:

# 解析 JSON 响应

try:

json_data = response.json()

print("JSON 数据:")

print(json_data)


# 提取下载链接

download_url = json_data.get("download_url")

if download_url:

# 修复下载链接中的反斜杠

download_url = download_url.replace("\\/", "/")

print("修复后的下载链接:", download_url)


# 下载文件

file_response = requests.get(download_url, headers=headers, stream=True)

if file_response.status_code == 200:

# 从 Content-Disposition 头中提取文件名

content_disposition = file_response.headers.get("Content-Disposition")

if content_disposition:

# 提取文件名，例如：attachment; filename="2025_Gameplay_Update.zip"

filename = re.findall('filename="?(.+)"?', content_disposition)[0]

filename = unquote(filename) # 解码 URL 编码的文件名

print(filename)

else:

# 如果 Content-Disposition 不存在，从 URL 中提取文件名

filename = re.findall('ZipFileName=([^&]+)', download_url)[0]

filename = unquote(filename) # 解码 URL 编码的文件名


print("保存文件名:", filename)



