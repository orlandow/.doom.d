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

;; FIXME: not working
(add-hook! clojure-mode
  (set-popup-rule! "^\\*cider-repl" :side 'right :size 0.35 :quit 'other))

(setq cljr-suppress-middleware-warnings t)

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
;; ------------      APL                 -------------------
;; ---------------------------------------------------------

(after! gnu-apl-mode
  (setq gnu-apl-mode-map-prefix "M-"
        gnu-apl-show-tips-on-start nil
        gnu-apl-show-apl-welcome nil)

  (defun my/gnu-apl-interactive-send-line ()
    (interactive)
    (let* ((line (buffer-substring (line-beginning-position) (line-end-position)))
           (b (get-buffer-create "*gnu-apl*"))
           (proc (get-buffer-process b))
           (m (process-mark proc)))
      (with-current-buffer b
        (goto-char (marker-position m))
        (insert line)
        (insert "\n")
        (set-marker m (point)))
      (gnu-apl-interactive-send-string line)))

  (map!
   :map gnu-apl-mode-map
   :localleader
   :desc "APL interactive"
   :nv "c" #'gnu-apl)

  (map!
   :map gnu-apl-mode-map
   :localleader
   :desc "APL send line to interactive"
   :nv "ef" #'my/gnu-apl-interactive-send-line)

  (map!
   :map gnu-apl-mode-map
   :localleader
   :desc "APL show keyboard"
   :nv "k" #'gnu-apl-show-keyboard)
  )

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

(map!
 :leader
 :desc "Narrow or widen dwim"
 :nv "zz" #'my/narrow-or-widen-dwim)

;; ---------------------------------------------------------
;; SPC * without regex quote

(defun my/search-project-for-symbol-at-point ()
  (interactive)
  (+default/search-project-for-symbol-at-point
   (or (doom-thing-at-point-or-region) "")))

(map!
 :leader
 :desc "Search for symbol at point in current project"
 :nv "*" #'my/search-project-for-symbol-at-point)
