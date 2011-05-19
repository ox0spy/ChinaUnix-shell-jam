#!/bin/bash

# 用shell写一个cgi脚本，提供一个简单的webmail介面，将本地的一个文件通过web服务器发送到指定的邮箱

echo Content-type: text/html
echo ""

email=$(echo "$QUERY_STRING" | sed -n 's/^.*email=\([^&]*\).*$/\1/p' | sed "s/%40/@/g")
file_name=$(echo "$QUERY_STRING" | sed -n 's/^.*file_name=\([^&]*\).*$/\1/p' | sed "s/%20/ /g")

/bin/cat << EOF
<html>
<head>
  <title>webmail cgi</title>
</head>
<body>
EOF
if [ -z $email  -o -z $file_name ]; then
	/bin/cat << EOF
  <form method="get">
    Email: <input type="text" name="email"/><br />
    File : <input type="file" name="file_name"/><br />
    <input type="submit" value="submit"/><br />
  </form>
EOF
else
	mail -s $file_name $email < $file_name \
		&& echo "Done.</br>" \
		|| echo "Error ..."
	#echo "email: $email</br>"
	#echo "file_name: $file_name</br>"
fi

/bin/cat << EOF
</body>
</html>
EOF
