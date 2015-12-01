VIRTUALS="false"

if [ $# -eq 1 ]
then
    case $1 in
	-v) VIRTUALS="true";;
    esac
fi



for file in \
    bin \
    Documents \
    hosts \
    java \
    kSar-5.0.6 \
    lib \
    NetBeansProjects \
    oracle \
    src
do
    echo -e "\n############   $file ..."
    rsync -av --delete $file  mnt/disk1/bbnthwa/backups/bbnthwa/
done


for file in \
     .kde4 \
    .bashrc \
    .emacs* \
    .netbeans/7.2.1 \
    .nx \
    .pw \
    .sqldeveloper \
    .ssh \
    .bbnthwa \
    .a-bbnthwa \
    .subversion 
do
    echo -e "\n############   $file ..."
    rsync -av --delete $file  mnt/disk1/bbnthwa/backups/bbnthwa/
done


if [ $VIRTUALS = "true" ]
then

    for file in \
	/virtuals/LinuxMint9 
#   /virtuals/Boxray11.2
    do
	echo -e "\n############   $file ..."
	rsync -av --delete $file  mnt/disk1/bbnthwa/backups/virtuals/
    done
fi


