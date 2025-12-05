(setq buffer-file-coding-system 'utf-8-unix)

(setq make-backup-files nil)

(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-p") 'move-line-up)
(global-set-key (kbd "M-n") 'move-line-down)

(global-set-key (kbd "
M-g") 'goto-line)

(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode) . lsp)
  :config
  (setq lsp-clients-clangd-args
        '("--compile-commands-dir=./"
          "--completion-style=detailed"))
  )

(defun regenerate-compile-commands ()
  (when (string-equal (buffer-name) "Makefile")
    (shell-command "bear -- make")))

(add-hook 'after-save-hook 'regenerate-compile-commands)

(defun my/set-compile-command-from-lsp-root ()
  (when (lsp-workspace-root)
    (setq compile-command
          (concat "make -C " (lsp-workspace-root))))) 

(add-hook 'lsp-mode-hook 'my/set-compile-command-from-lsp-root)
