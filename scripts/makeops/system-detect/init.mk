# Initialise `make` and define supporting targets.

# ==============================================================================

help: ### List targets
	@awk 'BEGIN {FS = ":.*?### "} /^[ a-zA-Z0-9_-]+:.*? ### / {printf "\033[36m%-41s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

show-configuration: ### Print all the variables
	$(foreach v, $(sort $(.VARIABLES)),
		$(if $(filter-out default automatic, $(origin $v)),
			$(if $(and $(patsubst %_PASSWORD,,$v), $(patsubst %_PASS,,$v), $(patsubst %_KEY,,$v), $(patsubst %_SECRET,,$v)),
				$(info $v=$($v) ($(value $v)) [$(flavor $v),$(origin $v)]),
				$(info $v=****** (******) [$(flavor $v),$(origin $v)])
			)
		)
	)

# ==============================================================================

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:
.NOTPARALLEL:
.ONESHELL:
.PHONY: *
MAKEFLAGS := --no-print-director
SHELL := /bin/bash
ifeq (true, $(shell [[ "$(DEBUG)" =~ ^(true|yes|y|on|1|TRUE|YES|Y|ON)$$ ]] && echo true))
	.SHELLFLAGS := -cex
else
	.SHELLFLAGS := -ce
endif

# ==============================================================================

.SILENT: \
	show-configuration
