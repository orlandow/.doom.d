;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Orlando"
      user-mail-address "orlando.cu@hotmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Pro" :size 15 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "Monaco" :size 14))

(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

 ;; more common use case
(setq evil-ex-substitute-global t)

;; Prevents some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Disable invasive lsp-mode features
(setq lsp-ui-sideline-enable nil   ; not anymore useful than flycheck
      lsp-ui-doc-enable nil        ; slow and redundant with K
      lsp-enable-symbol-highlighting nil
      ;; If an LSP server isn't present when I start a prog-mode buffer, you
      ;; don't need to tell me. I know. On some systems I don't care to have a
      ;; whole development environment for some ecosystems.
      +lsp-prompt-to-install-server 'quiet)

;; Configure Avy to work on all visible windows
(setq avy-all-windows t)

(setq fancy-splash-image (concat doom-private-dir "splash.png"))
;;(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(delete (assoc "Open org-agenda" +doom-dashboard-menu-sections) +doom-dashboard-menu-sections)

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)

;; keybindings in another file
(load! "keybindings.el")

;; open maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; no frame title
(setq frame-title-format nil)

;; , as the local leader (major mode)
(setq doom-localleader-key ",")

(setq auto-save-visited-mode t
      auto-save-visited-interval 3)

;; ---------------------------------------------------------
;; ------------      Clojure             -------------------
;; ---------------------------------------------------------
(add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
(add-hook 'clojurescript-mode-hook
            '(lambda ()
               (add-to-list 'imenu-generic-expression
                            '("re-frame" "(reg-\\(event-fx\\|event-db\\|sub\\)[ \\|\n]*\\(:[^ \\|\n]*\\)" 2) t)))

(after! cider
  (setq cljr-suppress-middleware-warnings t)
  (set-popup-rule! "^\\*cider-repl" :side 'right :size 0.35 :quit 'other))

;; clojure and cljs green icons (also including edn)
(after! all-the-icons
  (add-to-list 'all-the-icons-icon-alist
               '("\\.edn$"
                 all-the-icons-alltheicon
                 "clojure"
                 :height 1.0
                 :face all-the-icons-lyellow
                 :v-adjust 0.0))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.cljc?$"
                 all-the-icons-alltheicon
                 "clojure"
                 :height 1.0
                 :face all-the-icons-lgreen
                 :v-adjust 0.0))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.cljs$"
                 all-the-icons-fileicon
                 "cljs"
                 :height 1.0
                 :face all-the-icons-lgreen
                 :v-adjust 0.0)))

;; ---------------------------------------------------------
;; ------------      Web Dev             -------------------
;; ---------------------------------------------------------
(after! css-mode
  (setq web-mode-css-indent-offset 2
        css-indent-offset 2))

;; ---------------------------------------------------------
;; ------------      DAP Mode            -------------------
;; ---------------------------------------------------------

;; (after! dap-mode
;;   (setq dap-auto-configure-features '(breakpoints sessions locals expressions))
;;   (dap-ui-controls-mode -1))

;; ---------------------------------------------------------
;; ------------      restclient          -------------------
;; ---------------------------------------------------------
(after! restclient-mode
  (set-popup-rule! "^\\*HTTP Response*" :side 'right :size 0.35 :quit 'current))

;; ---------------------------------------------------------
;; ------------      Emacs lisp          -------------------
;; ---------------------------------------------------------

(after! flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; ---------------------------------------------------------
;; ------------      Org mode            -------------------
;; ---------------------------------------------------------

(defun my/org-inline-css-hook (exporter)
  "Insert custom inline css to automatically set the
background of code to whatever theme I'm using's background"
  (when (eq exporter 'html)
    (let* ((my-pre-bg (face-background 'default))
           (my-pre-fg (face-foreground 'default)))
      (setq
       org-html-head-extra
       (concat
        org-html-head-extra
        (format "<style type=\"text/css\">\n pre.src {background-color: %s; color: %s;}</style>\n"
                my-pre-bg my-pre-fg))))))

(setq org-directory "~/projects/org/"
      org-archive-location (concat org-directory ".archive/%s::")
      org-roam-directory (concat org-directory "roam/")
      org-roam-db-location (concat org-directory ".org-roam.db"))

(after! org-mode
  (add-hook 'org-export-before-processing-hook 'my/org-inline-css-hook)
  (add-to-list 'org-html-text-markup-alist
               '(verbatim . "<code class=\"verbatim\">%s</code>"))

  ;; Messes up with html export theme
  (setq org-html-table-default-attributes '()
        org-html-postamble nil))

(after! org-roam-mode
  (set-company-backend! 'org-roam-mode 'company-capf))

;; ---------------------------------------------------------
;; ------------      MISC                -------------------
;; ---------------------------------------------------------

;; ---------------------------------------------------------
;; Narrow
(defun my/narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, subtree, or defun, whichever applies
first.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p) (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

;; ---------------------------------------------------------
;; SPC * without regex quote

(defun my/search-project-for-symbol-at-point ()
  (interactive)
  (+default/search-project-for-symbol-at-point
   (or (doom-thing-at-point-or-region) "")))

;; ---------------------------------------------------------
;; Add current buffer to persp

(defun my/add-current-buffer-to-persp ()
  (interactive)
  (persp-add-buffer (current-buffer))
  (message "added buffer to persp"))

;; ---------------------------------------------------------
;; Doom features

(defun doom/ediff-init-and-example ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "init.el")
               (concat doom-emacs-dir "init.example.el")))

(define-key! help-map
  "di"   #'doom/ediff-init-and-example)

;; ---------------------------------------------------------
;; Theme

(custom-set-faces! '(ivy-minibuffer-match-face-1 :foreground "#bbc2cf"))

;; ---------------------------------------------------------
;; Emacs Everywhere

;; (add-to-list 'emacs-everywhere-markdown-apps
;;              "Slack")
