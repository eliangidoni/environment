# Pull master branch from all directories in current path.
#

for i in *; do
	if [ -d "$i" ]; then
		cd $i;
		git status > /dev/null 2>&1;
		if [ $? -eq 0 ]; then
			MASTER_BRANCH=$(git remote show origin | grep "HEAD branch" | cut -d ":" -f2);
			CUR_BRANCH=$(git branch | grep '* ' | tr -d '* ');
			git checkout $MASTER_BRANCH;
			if [ $? -eq 0 ]; then
				echo; echo "##### REPO ${i} #####";
				git pull;
				git checkout $CUR_BRANCH;
			fi
		fi
	fi
	cd ..;
done

