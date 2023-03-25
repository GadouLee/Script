#!/bin/bash
#青龙一键安装脚本
#我的仓库：https://github.com/GWen124
image="elecv2/elecv2p"
name="V2P"
menuname="V2P面板"
port="15800"
path="/opt/Docker/V2P"
blue() {
    echo -e "\033[34m\033[01m$1\033[0m"
}
green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}
red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}
install() {
    if ! command -v docker &> /dev/null; then
        red "错误：Docker 未安装，请先安装 Docker。"
        echo "请按照以下指引安装 Docker:"
        echo "https://docs.docker.com/get-docker/"
		echo "如需一键安装，请打开下面连接使用我的一键脚本集合:"
        echo "https://wen124.ml/FSWKKD"
        exit 1
    fi
while true; do
  read -r -p "$(yellow '请输入你的端口号(默认为'"$port"')：')" port_input
  if [ -n "$port_input" ]; then
      if ! [[ "$port_input" =~ ^[0-9]+$ ]] || [ "$port_input" -lt 1 ] || [ "$port_input" -gt 65535 ]; then
          echo "输入的端口号无效，请输入一个 1-65535 的整数或者Ctrl+C。"
          continue
      fi
      port="$port_input"
  fi
  read -r -p "$(yellow '请输入你的数据目录(默认为'"$path"')：')" path_input
  if [ -n "$path_input" ]; then
      if [ -d "$path_input" ]; then
          read -p "目录已经存在，是否要覆盖(Y/N)?" choice
          case "$choice" in
              y|Y ) rm -rf "$path_input"; mkdir -p "$path_input"; path="$path_input";;
              n|N ) echo "请修改数据目录后重新执行脚本。"; exit 1;;
              * ) echo "请输入 Y 或 N或者Ctrl+C。"; exit 1;;
          esac
      else
          mkdir -p "$path_input"
          path="$path_input"
      fi
  fi
  yellow "你确定输入的端口和路径正确吗"
  read -p "继续安装容器(Y)，请重新输入端口号和数据目录(N)，退出脚本(R):" confirm
  case "$confirm" in
      y|Y ) break;;
      n|N ) continue;;
      r|R ) exit 1;;
      * ) yellow "请输入 Y 或 N 或 R或者Ctrl+C。";;
  esac
done
docker run --restart=always \
  -d --name "$name" \
  -e TZ=Asia/Shanghai \
  -p "$port":80 -p 8101:8001 -p 8102:8002 \
  -v /"$path"/JSFile:/usr/local/app/script/JSFile \
  -v /"$path"/Lists:/usr/local/app/script/Lists \
  -v /"$path"/Store:/usr/local/app/script/Store \
  -v /"$path"/Shell:/usr/local/app/script/Shell \
  -v /"$path"/rootCA:/usr/local/app/rootCA \
  -v /"$path"/efss:/usr/local/app/efss \
  "$image"
    yellow "容器已启动，端口号为 $port，数据目录为 $path"
}
update() {
    if ! command -v docker &> /dev/null; then
        red "错误：Docker 未安装，请先安装 Docker。"
        echo "请按照以下指引安装 Docker:"
        echo "https://docs.docker.com/get-docker/"
        echo "如需一键安装，请打开下面连接使用我的一键脚本集合:"
        echo "https://wen124.ml/FSWKKD"
        exit 1
    fi
    if true; then
        green "================================================="
    red "		注意！！！"
	red "1.如果是自定义设置的路径："
    red "  更新前请牢记你映射的目录路径，并严格对应输入！"
    red "  如果输入错误，可能将导致设置与数据丢失！"
    red "2.如果是使用此脚本默认安装："
    red "  则不做任何输入，以保持默认路径，"
    red "  如错误输入，届时与原路径不符，同样丢失数据！"
        green "================================================="
        while true; do
            read -n 1 -rp "$(yellow '确定要更新吗 ?[y/n]：')" confiup
            echo
            if [[ "$confiup" =~ ^[Yy]$ ]]; then
                break
            elif [[ "$confiup" =~ ^[Nn]$ ]]; then
                exit
            else
                echo "$(red '无效输入，请重新输入或者Ctrl+C。')"
            fi
        done
        while true; do
            read -rp "$(yellow '请输入你的端口号（默认为'"$port"'）：')" port_input
            if [ -z "$port_input" ]; then
                break
            elif [[ "$port_input" =~ ^[0-9]+$ ]]; then
                port="$port_input"
                break
            else
                echo "$(red '无效输入，请重新输入或者Ctrl+C。')"
            fi
        done
        while true; do
            read -rp "$(yellow '请输入你的数据目录路径（默认为'"$path"'）：')" path_input
            if [ -z "$path_input" ]; then
                break
            elif [ -d "$path_input" ]; then
                path="$path_input"
                break
            else
                echo "$(red '无效路径，请重新输入或者Ctrl+C。')"
            fi
        done
        green "容器即将更新"
        docker pull $image
        docker stop $name && docker rm $name
        green "容器更新中..."
docker run --restart=always \
  -d --name "$name" \
  -e TZ=Asia/Shanghai \
  -p "$port":80 -p 8101:8001 -p 8102:8002 \
  -v /"$path"/JSFile:/usr/local/app/script/JSFile \
  -v /"$path"/Lists:/usr/local/app/script/Lists \
  -v /"$path"/Store:/usr/local/app/script/Store \
  -v /"$path"/Shell:/usr/local/app/script/Shell \
  -v /"$path"/rootCA:/usr/local/app/rootCA \
  -v /"$path"/efss:/usr/local/app/efss \
  "$image"
        green "容器已更新完成，端口号为 $port，数据目录为 $path"
    else
        yellow "已取消更新"
    fi
}
uninstall() {
    if ! command -v docker &> /dev/null; then
        red "错误：Docker 未安装，请先安装 Docker。"
        echo "请按照以下指引安装 Docker:"
        echo "https://docs.docker.com/get-docker/"
        echo "如需一键安装，请打开下面连接使用我的一键脚本集合:"
        echo "https://wen124.ml/FSWKKD"
        exit 1
    fi
    green "================================================="
    red "警告：该操作将会删除容器及其数据。"
    green "================================================="
    while true; do
        read -n 1 -rp "$(yellow '请再次确认是否删除容器 [y/n]：')" confirm
        echo
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            break
        elif [[ "$confirm" =~ ^[Nn]$ ]]; then
            exit
        else
            echo "$(red '无效输入，请重新输入或者Ctrl+C。')"
        fi
    done
    docker stop $name && docker rm $name
    yellow "容器已卸载"
    read -p "$(yellow '请输入你的数据目录路径（默认为'"$path"'）：')" custom_dir
    dir_to_delete=${custom_dir:-$path}
    while true; do
        read -n 1 -rp "$(yellow '请再次确认是否删除你的数据目录 [y/n]：')" delete_dir
        echo
        if [[ "$delete_dir" =~ ^[Yy]$ ]]; then
            rm -rf "$dir_to_delete"
            yellow "数据目录已删除"
            break
        elif [[ "$delete_dir" =~ ^[Nn]$ ]]; then
            yellow "数据目录未删除"
            break
        else
            echo "$(red '无效输入，请重新输入或者Ctrl+C。')"
        fi
    done
}
menu() {
  while true; do
    clear
    green "================================================="
    yellow " $menuname一键 Docker 脚本"
    yellow " 默认端口：$port"
    yellow " 默认路径：$path"
    green "================================================="
    blue "  1. 安装并启动容器"
    blue "  2. 更新容器"
    blue "  3. 卸载容器"
    blue "  0. 退出脚本"
    green "================================================="
    read -e -p "$(yellow '请输入数字 [0-3]:')" num
    case "$num" in
      1)
        rm -rf "$0"
        install
        break
        ;;
      2)
        rm -rf "$0"
        update
        break
        ;;
      3)
        rm -rf "$0"
        uninstall
        break
        ;;
      0)
        rm -rf "$0"
        exit 0
        ;;
      *)
        continue
        ;;
    esac
  done
}

menu