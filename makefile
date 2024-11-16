
fix:
	rubocop -A ./*.rb

pub:
	git status
	sleep 5
	git add .
	git commit -am 'update'
	git push
