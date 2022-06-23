(setq inhibit-splash-screen t)
(setq initial-buffer-choice nil)
(setq calendar-week-start-day 1)

(require 'org)

(setq default-directory "~/org")
(setq org-directory "~/org")
(setq org-agenda-files "~/org/agenda")
(setq org-agenda-archives-mode t)
(setq org-log-done 'time)
; (add-hook 'after-init-hook (lambda () (org-todo-list) (delete-other-windows)))
(add-hook 'after-init-hook (lambda () (cfw:open-org-calendar) (delete-other-windows)))


(setq org-capture-templates
      '(("s" "Schedule personal event" entry
        (file+headline "~/org/personal.org" "Schedule")
         "** %?\n   %(cfw:org-capture-day)")
        ("t" "Add personal todo" entry
        (file+headline "~/org/personal.org" "Tasks")
         "** TODO %?\n   %(cfw:org-capture-day)")))

(eval-after-load "calfw"
  '(progn
    (define-key cfw:calendar-mode-map "C" 'org-capture)))

(setq evil-undo-system 'undo-redo)
(require 'evil)
(evil-mode 1)

(require 'evil-org)
(add-hook 'org-mode-hook 'evil-org-mode)
(evil-org-set-key-theme '(navigation insert textobjects additional calendar))
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

(require 'calfw-org)
(setq cfw:render-line-breaker 'cfw:render-line-breaker-wordwrap)

(load-theme 'leuven)
