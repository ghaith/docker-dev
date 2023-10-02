---
marp: true
title: Remote Development in Neovim
theme: uncover
transition: fade
paginate: true
---

# Remote Development in neovim

---

# Current system

* Well configured neovim, locally installed environment. 
* It all works fine, thank you for your attention

---

# We have a problem... 

* Local environments have different versions for software dependencies.
* The LLVM API does not offer stability guarantees 
and needs to remain on the same version during development.
* Not every system needs the LLVM dependencies.
---

# The easy way

* There's a solution for that, [Dev containers](http://containers.dev)
* Dev containers integrate well with [Visual studio code](https://code.visualstudio.com/).
* So let's take a look at the devcontainer implementation for our project. [RuSTy](https://github.com/PLC-lang/rusty)
* This works just fine if you like VS Code...

---

# But I don't like VS Code 

* [distrobox](https://github.com/89luca89/distrobox) and [toolbox](https://github.com/containers/toolbox) are very good for such development environments.
* These tools have full access to your home dir, which I would like to avoid.

--- 

# Re-inventing the wheel

* So how about we create the same environment for my editor : [Docker-Dev](https://github.com/ghaith/docker-dev)
* I base on our original rust development image, and install additonal tool as well as my editors and config.
* From then on, I can attach to the image and develop as if it's local.

---

# Looking ahead

* The dev container protocol is no longer VS Code bound, and could possibly be expanded later to support neovim seamlessly.
* [Devpod](https://devpod.sh/) is an opensource implementation of codespaces that also works on terminals.
* [nix](https://nixos.org/) seems like a perfect fit for this problem, but I have not gotten the change to dive into it.

---

# Thank you for your attention

* ## Questions?

