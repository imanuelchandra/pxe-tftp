AUTHOR?=imanuelchandra
REPOSITORY?=pxe-tftp

.PHONY: build
build_pxe_tftpd:
	docker build -t ${AUTHOR}/${REPOSITORY}:${PXE_TFTP_SERVER_VERS}  . \
			--build-arg A_TFTP_DIRECTORY=${TFTP_DIRECTORY} \
			--build-arg A_TFTPD_EXTRA_ARGS=${TFTPD_EXTRA_ARGS} \
			--progress=plain \
			--no-cache
	@echo
	@echo "Build finished. Docker image name: \"${AUTHOR}/${REPOSITORY}:${PXE_TFTP_SERVER_VERS}\"."

.PHONY: run
run_pxe_tftpd:
	docker run -it --rm --privileged --init --user 6565:6565 -p 80:80 --net host \
			-e TFTP_DIRECTORY=${TFTP_DIRECTORY} \
			-e TFTPD_EXTRA_ARGS=${TFTPD_EXTRA_ARGS} \
	    	-v ./config:/config \
			-v ./log:/log \
			-v ./scripts:/scripts \
			--mount 'type=volume,dst=${NFS_LOCAL_MNT},volume-driver=local,volume-opt=type=nfs,volume-opt=device=:${NFS_SHARE},"volume-opt=o=addr=${NFS_SERVER},${NFS_OPTS}"' \
			${AUTHOR}/${REPOSITORY}:${PXE_TFTP_SERVER_VERS} eth0