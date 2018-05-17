:loop
	
	:: Navigate to the directory you wish to push to GitHub
	::Change <path> as needed.
	Z:
	cd "Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo"
	
	::Initialize GitHub
	git init
	
	::Pull any external changes (maybe you deleted a file from your repo?)
	git pull
	
	::Add all files in the directory
	git add --all
	
	::Commit all changes with the message "auto push". 
	::Change as needed.
	git commit -m "automated push"
	
	::Push all changes to GitHub 
	git push
	
	::Quit
	exit
	
::Restart from the top.	
goto loop