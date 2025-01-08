(require 'cal-china-x)
(require 'cnfonts)

(defvar chinese-holidays nil
  "French holidays")

(defvar paid-holidays nil
  "Paid holidays")

(setq chinese-holidays cal-china-x-chinese-holidays)

(setq calendar-holidays (append chinese-holidays     ; Chinese holidays
				paid-holidays) ; Paid holiday
      calendar-week-start-day 1             ; Week starts on Monday
      calendar-mark-diary-entries-flag nil) ; Do not show diary entries

; Mark today in calendar
(add-hook 'calendar-today-visible-hook  #'calendar-mark-today)
