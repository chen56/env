# 检查格式cat -e -t -v  Makefile


all: status

destroy:
	vagrant destroy -f

rebuild: destroy
	vagrant up
    
save: 
	vagrant snapshot save -f env_one xxx

restore: 
	vagrant snapshot restore --no-provision env_one xxx
    
reload: 
	vagrant reload --no-provision
