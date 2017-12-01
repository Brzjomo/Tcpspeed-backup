#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


install_path=/xs/
package_download_url=http://www.tcpspeed.co/tcpspeed/tcpspeed_server.zip
package_save_name=tcpspeed_server.zip
 
function checkjava(){
	java -version
	#echo $?
	if [[ $? -le 1 ]] ;then
		echo " Run java success"
	else
		echo " Run java failed"
		echo $OS
		if [[ $OS = "centos" ]]; then
			echo " Install  centos java ..."
			yum install -y java-1.8.0-openjdk
		fi
		if [[ $OS = "ubuntu" ]]; then
			echo " Install  ubuntu java ..."
			apt-get -y install default-jre
		fi
		if [[ $OS = "debian" ]]; then
			echo " Install  debian java ..."
			apt-get -y install default-jre
		fi
	fi
	# if [[ ! -d "$result" ]]; then
		# echo "不存在"
	# else
		# echo "存在"
	# fi
	echo $result
}


function checkunzip(){
	unzip
	#echo $?
	if [[ $? -le 1 ]] ;then
		echo " Run unzip success"
	else
		echo " Run unzip failed"
		echo $OS
		if [[ $OS = "ubuntu" ]]; then
			echo " Install  ubuntu unzip ..."
			apt-get -y install unzip
		fi
		if [[ $OS = "debian" ]]; then
			echo " Install  debian unzip ..."
			apt-get -y install unzip
		fi
		if [[ $OS = "centos" ]]; then
			echo " Install  centos unzip ..."
			yum install -y unzip
		fi
	fi
	# if [[ ! -d "$result" ]]; then
		# echo "不存在"
	# else
		# echo "存在"
	# fi
	echo $result
}

function checkwget(){
	wget
	#echo $?
	if [[ $? -le 1 ]] ;then
		echo " Run wget success"
	else
		echo " Run wget failed"
		echo $OS
		if [[ $OS = "ubuntu" ]]; then
			echo " Install  ubuntu wget ..."
			apt-get -y install wget
		fi
		if [[ $OS = "debian" ]]; then
			echo " Install  debian wget ..."
			apt-get -y install wget
		fi
		if [[ $OS = "centos" ]]; then
			echo " Install  centos wget ..."
			yum install -y wget
		fi
	fi
	echo $result
}


function checkenv(){
		if [[ $OS = "ubuntu" ]]; then
			apt-get update
			apt-get -y install libpcap-dev
			apt-get -y install iptables
		fi
		if [[ $OS = "debian" ]]; then
			echo "apt-get updateapt-get updateapt-get update"
			apt-get update
			apt-get -y install libpcap-dev
			apt-get -y install iptables
		fi
		if [[ $OS = "centos" ]]; then
			yum -y update
			yum -y install libpcap
			yum -y install iptables
		fi
}



function checkos(){
    if [[ -f /etc/redhat-release ]];then
        OS=centos
    elif [[ ! -z "`cat /etc/issue | grep bian`" ]];then
        OS=debian
    elif [[ ! -z "`cat /etc/issue | grep Ubuntu`" ]];then
        OS=ubuntu
    else
        echo "Unsupported operating systems!"
        exit 1
    fi
	echo $OS
}

 
#  Install TCPSpeed
function install_tcpspeed(){
	rm -f $package_save_name
	echo "Download software..."
	if ! wget -O $package_save_name $package_download_url ; then
		echo "Download software failed!"
		exit 1
	fi

	if [[ ! -d "$install_path" ]]; then
		mkdir "$install_path"
		else
		echo "Update Software..."
	fi
	
	unzip -o $package_save_name  -d $install_path
	
	rm -f /etc/init.d/tcpspeed ; cp /xs/tcpspeed  /etc/init.d;rm -f /xs/tcpspeed ;
	chmod +x /etc/init.d/tcpspeed
	if [ "$OS" == 'centos' ]; then
		chkconfig --add tcpspeed;
		chkconfig tcpspeed on;
    else
        update-rc.d -f tcpspeed defaults
    fi
	
	sh /xs/stop.sh
	sh /xs/start.sh
}


checkos
checkenv
checkwget
checkjava
checkunzip
install_tcpspeed
