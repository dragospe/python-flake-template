##
# Author: Peter Dragos
# Repository: https://github.com/dragospe/python-flake-template
#
# @file
# @version 0.1

.PHONY: build watch test format format_check lint lint_check requires_nix_shell \
  format_python format_check_python format_nix format_check_nix typecheck lint

usage:
	@echo "usage: make <command>"
	@echo
	@echo "Available commands:"
	@echo "  build               -- Run a \`poetry2nix\` build"
	@echo "  watch [COMMAND]     -- Track files and run 'make COMMAND' on change"
	@echo "  test                -- Run pytest"
	@echo "  check               -- Run formatting, linting, and type checks"
	@echo "  format              -- Apply nix and python source code formatting"
	@echo "  format_check        -- Check source code formatting without making changes"
	@echo "  format_python       -- Run \`black\` to reformat python code"
	@echo "  format_check_python -- Run \`black\` to check for format errors"
	@echo "  format_nix          -- Run \`nixpkgs-fmt\` to format nix code"
	@echo "  format_check_nix    -- Run \`nixpkgs-fmt\` to check nix files for format errors"
	@echo "  typecheck           -- run \`mypy\`"
	@echo "  lint                -- Check the sources with pylint and flake8"

## Bookkeeping

# Target to use as dependency to fail if not inside nix-shell
requires_nix_shell:
	@ [ -v IN_NIX_SHELL ] || echo "The $(MAKECMDGOALS) target must be run \
         from inside nix-shell"
	@ [ -v IN_NIX_SHELL ] || (echo "    run 'nix develop .' first" && false)

## Project

build: requires_nix_shell
	nix build

watch: requires_nix_shell
	while sleep 1; \
	do \
	  fd -e '.py' -e '.toml' | \
		  entr -cd make $(filter-out $@,$(MAKECMDGOALS)); \
  done

## Tests and Benchmarks

test: requires_nix_shell
	pytest

## Formatting and linting

check: format_check lint typecheck

format: format_python format_nix

format_check: format_check_python format_check_nix

format_python: requires_nix_shell
	black -l 80 ./

format_check_python: requires_nix_shell
	@echo "########################################"
	@echo "##          Running black             ##"
	@echo "########################################"
	@echo ""
	@black -l 80 --check ./
	@echo ""

format_nix: requires_nix_shell
	nixpkgs-fmt ./flake.nix

format_check_nix:
	@echo "########################################"
	@echo "##          Running nixpgs-fmt        ##"
	@echo "########################################"
	@echo ""
	@nixpkgs-fmt --check ./flake.nix
	@echo ""

lint:
	@echo "########################################"
	@echo "##          Running pylint            ##"
	@echo "########################################"
	@echo ""
	@pylint --recursive y ./
	@echo ""
	@echo "########################################"
	@echo "##          Running flake8            ##"
	@echo "########################################"
	@echo ""
	@fd -e '.py' -X flake8 {} ;
	@echo ""

typecheck:
	@echo "########################################"
	@echo "##          Running mypy              ##"
	@echo "########################################"
	@echo ""
	@mypy --strict ./
	@echo ""
