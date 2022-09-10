##
# [TODO: RENAME ME]: Stub Makefile. Add your name here
#
# @file
# @version 0.1

.PHONY: build watch test format format_check lint lint_check requires_nix_shell \
  bench ci

usage:
	@echo "usage: make <command>"
	@echo
	@echo "Available commands:"
	@echo "  build               -- Run cabal v2-build"
	@echo "  watch [COMMAND]     -- Track files and run 'make COMMAND' on change"
	@echo "  test                -- Run cabal v2-test"
	@echo "  format              -- Apply source code formatting with fourmolu"
	@echo "  format_check        -- Check source code formatting without making changes"
	@echo "  format_python"
	@echo "  format_check_python    -- Check nix files for format errors"
	@echo "  format_nix"
	@echo "  format_check_nix    -- Check nix files for format errors"
	@echo "  format_python"
	@echo "  lint                -- Check the sources with hlint"
	@echo "  lint_refactor"
	@echo "  bench               -- Run script benchmark suite"
	@echo "  ci                  -- Run the whole CI check via nix"

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

format: format_python format_nix

format_check: format_check_python format_check_nix

format_python: requires_nix_shell
	black -l 80 -v -t py311 ./

format_check_python: requires_nix_shell
	black -l 80 --check -v -t py311 ./

format_nix: requires_nix_shell
	nixpkgs-fmt ./flake.nix

format_check_nix:
	nixpkgs-fmt --check ./flake.nix

lint:
	pylint --recursive y ./
#	@echo "  bench               -- Run script benchmark suite"
#	@echo "  ci                  -- Run the whole CI check via nix"
