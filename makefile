
pwd = $(shell pwd)
name = "mousetrap"
email = $(shell cat "$$HOME/.secret/email.txt")
version = $(shell yq ".project.version" pyproject.toml)

venv = $(pwd)/.venv
venvbin = $(venv)/bin
activate = $(venv)/bin/activate

define clear_dir
    if [ -d $(1) ]; then rm -r $(1); fi
    mkdir $(1)
endef

$(venv): $(venvbin)
	touch $(venv)

$(venvbin): $(activate) requirements.txt
	. .venv/bin/activate && \
	pip install -r requirements.txt
	touch $(venvbin)

$(activate):
	python -m venv --prompt $(name) .venv
	. .venv/bin/activate && \
	pip install --upgrade pip;
	sed 's/NAME/$(name)/' pyproject.toml > pyproject.toml

# Make sure to have a public branch, possibly by running make share_init
share: $(venv)
	git checkout gh-pages && \
	git push public --tags

to_github:
	$(eval user_name = $(shell yq ".git.github" pyproject.toml))
	curl -u "$(user_name)" "https://api.github.com/user/repos" -d "{\"name\":\"$(name)\",\"private\":false}"

share_init:
	git checkout -b gh-pages
	git commit --allow-empty -m "Initialising gh-pages branch"
	$(eval user_name = $(shell yq ".git.github" pyproject.toml))
	git remote add github "https://github.com/$(user_name)/$(name)"
	git remote add public "/mnt/nas/git/q"
	git remote set-url --add --push public "/mnt/nas/git/q"
	git remote set-url --add --push public "https://github.com/$(user_name)/$(name)"
	git push public gh-pages

clean:
	rm -r .venv

