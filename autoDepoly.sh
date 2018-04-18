echo "Script Starting"
echo "----Cleaning"
hexo clean
echo "----Generating"
hexo g


read -r -p "Do u want to run server to debug? [Y/else] " input

case $input in
	[yY][eE][sS]|[yY])
		echo "----Starting server in debug mode"
		hexo s --debug
		;;

	*)
	echo "Skip server"
	;;
esac

read -r -p "Do u want to Deploying? [Y/else] " input

case $input in
	[yY][eE][sS]|[yY])
		echo "----Deploying"
		hexo d
		;;

	*)
	echo "Skip deploy..."
	;;
esac

read -r -p "Do u want to git push? [Y/else] " input

case $input in
	[yY][eE][sS]|[yY])
		echo "----Git Add"
		git add .
		echo "----Git Commit"
		git commit -m "Update"
		echo "----Git Push"
		git push
		;;

	*)
	echo "Skip git push..."
	;;
esac



echo "All Finaish!"
read -p "Press any key to exit." var