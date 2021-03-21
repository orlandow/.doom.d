;;; old/apl.el -*- lexical-binding: t; -*-
(package! gnu-apl-mode)

;; ---------------------------------------------------------
;; ------------      APL                 -------------------
;; ---------------------------------------------------------
;; (use-package! gnu-apl-mode
;;   :config
;;   (setq gnu-apl-mode-map-prefix "M-"
;;         gnu-apl-interactive-mode-map-prefix "M-"))

(after! gnu-apl-mode
  (setq gnu-apl-mode-map-prefix "M-"
        gnu-apl-show-tips-on-start nil
        gnu-apl-show-apl-welcome nil)
  (gnu-apl--set-mode-map-prefix 's 'M)

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

  (font-lock-add-keywords 'gnu-apl-mode
                          '(("¯?[0-9][¯0-9A-Za-z]*" . 'highlight-numbers-number)
                            ("[|,*¯?!+-]" . 'font-lock-keyword-face)
                            ("[⌈⌊⍴∼⍳×÷⌹○⌽⊖⍋⍒⍎⍕⍉∈∊⍷↑↓⊥⊤\\\/⍟⍉<>≤=≥≠∨∧⍱⍲⊣⊢≡≢⍪⊂⊃~∪∩⌷⍬]" . 'font-lock-keyword-face)
                            ("[⌿⍀.∘⌸⍤⍨⍣¨]". 'font-lock-keyword-face)
                            ("[∇←→⍵⍺⎕]". 'font-lock-builtin-face)))

  ;; TODO: consider moving to keybindings.el
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
