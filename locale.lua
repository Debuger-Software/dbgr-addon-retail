_Lang = {"EN", "PL"};

_Lang["EN"] = {
    MAILBOX                 = "MAILBOX",
    ITEMS_IN_MAILS          = "Items in mails: ",
    GOLD_IN_MAILS           = "Gold in mails: ",
    MAIL_INFO_TEXT          = "You have |cFFFF00FF %d|r mails.\n%s\n%s",
    EMPTY_INBOX             = "Inbox is empty",
    UNSPENT_TALENTS         = "You have free %d unspent talent points!",
    UNSPENT_TALENTS_TITLE   = "Spend Your Talent Points",
    AH_ITEM_SELL            = "AH item sell: %s",
    AH_OUTBID               = "OUTBID: %s",
    AFK_WARN                = "Move or your character has been logout soon!",
    SETTINGS                = "SETTINGS",
    CHAT_ICON_SIZE_LABEL    = "Chat icons size",
    DEFAULT_SETTINGS_LOADED = "Default settings loaded.",
    SET_LABEL_NOTIFY_SND    = "Notification sounds",
    SET_LABEL_AH_RELATED    = "Auction House related notifications",
    SET_LABEL_AFK_WARNS     = "AFK warnings",
    SET_LABEL_EXP_INFO      = "Experience related info (on chat)",
    SET_BTN_RESTORE_DEF     = "Restore Defaults",
    SET_BTN_SAVE            = "Save & Reload",
    TOTAL                   = "Total",
    PLAY_TIME_STATS         = "Play time statistics",
};
_Lang["PL"] = {
    MAILBOX                 = "SKRZYNKA POCZTOWA",
    ITEMS_IN_MAILS          = "Przedmioty w mailach: ",
    GOLD_IN_MAILS           = "Gold w mailach: ",
    MAIL_INFO_TEXT          = "Masz |cFFFF00FF %d|r wiadomosci.\n%s\n%s",
    EMPTY_INBOX             = "Skrzynka jest pusta",
    UNSPENT_TALENTS         = "Masz %d nieprzydzielonych punktów talentów!",
    UNSPENT_TALENTS_TITLE   = "ROZDAJ PUNKTY TALENTÓW",
    AH_ITEM_SELL            = "Sprzedane przedmioty: %s",
    AH_OUTBID               = "Twoja oferta w licytacji %s zostala przebita",
    AFK_WARN                = "Rusz sie, w przeciwnym wypadku Twoja postac zostanie niedługo wylogowana!",
    SETTINGS                = "USTAWIENIA",
    CHAT_ICON_SIZE_LABEL    = "Rozmiar ikon czatu",
    DEFAULT_SETTINGS_LOADED = "Przywrócono ustawienia domyslne.",
    SET_LABEL_NOTIFY_SND    = "Dzwiek podczas powiadomien",
    SET_LABEL_AH_RELATED    = "Powiadomienia dot. aukcji",
    SET_LABEL_AFK_WARNS     = "Ostrzezenie o bezczynnosci (AFK)",
    SET_LABEL_EXP_INFO      = "Szczegoly dot. zdobywanego dosw. (na czacie)",
    SET_BTN_RESTORE_DEF     = "Przywroc domyslne",
    SET_BTN_SAVE            = "Zapisz",
    TOTAL                   = "Razem",
    PLAY_TIME_STATS         = "Statystyki czasu gry",
};

function lang_exist(lang)
    for k, _ in pairs(_Lang) do if k == lang then return true end end
    return false
end
