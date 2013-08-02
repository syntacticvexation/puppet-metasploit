apply = puppet apply --noop --modulepath=..

test: tests/*.pp
	find tests -name \*.pp | xargs -n 1 -t $(apply)

