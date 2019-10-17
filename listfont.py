import codecs
import glob
import os
import struct
import sys

FONT_DIR_MACOSX = [
    os.path.expanduser("~") + "/Library/Fonts/",
    "/Library/Fonts/",
    "/System/Library/Fonts/",
    "/System/Library/Assets/com_apple_MobileAsset_Font5/"
]
FONT_DIR_TEXLIVE = [
    "/usr/local/texlive/2019/texmf-dist/fonts/opentype/",
    "/usr/local/texlive/2019/texmf-dist/fonts/truetype/"
]
FONT_DIR_ADOBE = [
    "/Applications/Adobe Acrobat Reader DC.app/Contents/Frameworks/Adobe3D.framework/Resources/",
    "/Applications/Adobe Acrobat Reader DC.app/Contents/Resources/Resource/CIDFont/",
    "/Applications/Adobe Acrobat Reader DC.app/Contents/Resources/Resource/Font/",
]
FONT_DIR_OFFICE = [
    # "/Applications/Microsoft Excel.app/Contents/Resources/DFonts",
    # "/Applications/Microsoft OneNote.app/Contents/Resources/DFonts",
    # "/Applications/Microsoft PowerPoint.app/Contents/Resources/DFonts",
    # "/Applications/Microsoft Excel.app/Contents/Resources/DFonts",
    "/Applications/Microsoft Word.app/Contents/Resources/DFonts"
]
FONT_DIR_USER = [
    # os.path.expanduser("~") + "/Files/Fonts/"
]
FONT_DIR = FONT_DIR_MACOSX + FONT_DIR_TEXLIVE + FONT_DIR_ADOBE + FONT_DIR_OFFICE + FONT_DIR_USER

FONT_FILE_EXT = [".otf", ".ttf", ".otc", ".ttc"]
FONT_COLLECTION_FILE_EXT = [".otc", ".ttc"]
FONT_FILE_EXT = FONT_FILE_EXT + [i.upper() for i in FONT_FILE_EXT]
FONT_COLLECTION_FILE_EXT = FONT_COLLECTION_FILE_EXT + [i.upper() for i in FONT_COLLECTION_FILE_EXT]

_TTC_TAG               = 0x74746366  # = "ttcf"
_SFNT_VERSION_CFF      = 0x4F54544F  # = "OTTO"
_SFNT_VERSION_TRUETYPE = 0x00010000

NAME_ID_DICT = {
    0:  "copyright",
    1:  "family_name",
    2:  "subfamily_name",
    4:  "full_name",
    5:  "version",
    6:  "postscript_name",
    8:  "manufacturer",
    9:  "designer",
    10: "desription",
    16: "typographic_family_name",
    17: "typographic_subfamily_name"
}
ENCODING_ID_DICT = {
    # Unicode platform
    (0, 0): "utf_16_be",
    (0, 1): "utf_16_be",
    (0, 2): "utf_16_be",
    (0, 3): "utf_16_be",
    (0, 4): "utf_16_be",
    (0, 5): "utf_16_be",
    (0, 6): "utf_16_be",
    # Macintosh platform
    (1, 0): "mac_roman",
    (1, 1): "cp932",
    (1, 2): "cp950",
    (1, 3): "cp949",
    (1, 4): "cp864",
    (1, 5): "cp1255",
    (1, 6): "mac_greek",
    (1, 7): "mac_cyrillic",
    (1, 25): "gbk",
    # Windows platform
    (3, 0): "utf_16_be",
    (3, 1): "utf_16_be",
    (3, 2): "shift_jis",
    (3, 3): "gb2312",
    (3, 4): "big5",
    (3, 10): "utf_16_be"
}
LANGUAGE_ID_DICT = {
    (0, 0): "UNICODE",
    # Macintosh platform
    (1, 0): "English",
    (1, 1): "French",
    (1, 2): "German",
    (1, 3): "Italian",
    (1, 4): "Dutch",
    (1, 5): "Swedish",
    (1, 6): "Spanish",
    (1, 7): "Danish",
    (1, 8): "Portuguese",
    (1, 9): "Norwegian",
    (1, 10): "Hebrew",
    (1, 11): "Japanese",
    (1, 12): "Arabic",
    (1, 13): "Finnish",
    (1, 14): "Greek",
    (1, 15): "Icelandic",
    (1, 16): "Maltese",
    (1, 17): "Turkish",
    (1, 18): "Croatian",
    (1, 19): "Chinese (Traditional)",
    (1, 20): "Urdu",
    (1, 21): "Hindi",
    (1, 22): "Thai",
    (1, 23): "Korean",
    (1, 24): "Lithuanian",
    (1, 25): "Polish",
    (1, 26): "Hungarian",
    (1, 27): "Estonian",
    (1, 28): "Latvian",
    (1, 29): "Sami",
    (1, 30): "Faroese",
    (1, 31): "Farsi/Persian",
    (1, 32): "Russian",
    (1, 33): "Chinese (Simplified)",
    (1, 34): "Flemish",
    (1, 35): "Irish Gaelic",
    (1, 36): "Albanian",
    (1, 37): "Romanian",
    (1, 38): "Czech",
    (1, 39): "Slovak",
    (1, 40): "Slovenian",
    (1, 41): "Yiddish",
    (1, 42): "Serbian",
    (1, 43): "Macedonian",
    (1, 44): "Bulgarian",
    (1, 45): "Ukrainian",
    (1, 46): "Byelorussian",
    (1, 47): "Uzbek",
    (1, 48): "Kazakh",
    (1, 49): "Azerbaijani (Cyrillic script)",
    (1, 50): "Azerbaijani (Arabic script)",
    (1, 51): "Armenian",
    (1, 52): "Georgian",
    (1, 53): "Moldavian",
    (1, 54): "Kirghiz",
    (1, 55): "Tajiki",
    (1, 56): "Turkmen",
    (1, 57): "Mongolian (Mongolian script)",
    (1, 58): "Mongolian (Cyrillic script)",
    (1, 59): "Pashto",
    (1, 60): "Kurdish",
    (1, 61): "Kashmiri",
    (1, 62): "Sindhi",
    (1, 63): "Tibetan",
    (1, 64): "Nepali",
    (1, 65): "Sanskrit",
    (1, 66): "Marathi",
    (1, 67): "Bengali",
    (1, 68): "Assamese",
    (1, 69): "Gujarati",
    (1, 70): "Punjabi",
    (1, 71): "Oriya",
    (1, 72): "Malayalam",
    (1, 73): "Kannada",
    (1, 74): "Tamil",
    (1, 75): "Telugu",
    (1, 76): "Sinhalese",
    (1, 77): "Burmese",
    (1, 78): "Khmer",
    (1, 79): "Lao",
    (1, 80): "Vietnamese",
    (1, 81): "Indonesian",
    (1, 82): "Tagalog",
    (1, 83): "Malay (Roman script)",
    (1, 84): "Malay (Arabic script)",
    (1, 85): "Amharic",
    (1, 86): "Tigrinya",
    (1, 87): "Galla",
    (1, 88): "Somali",
    (1, 89): "Swahili",
    (1, 90): "Kinyarwanda/Ruanda",
    (1, 91): "Rundi",
    (1, 92): "Nyanja/Chewa",
    (1, 93): "Malagasy",
    (1, 94): "Esperanto",
    (1, 128): "Welsh",
    (1, 129): "Basque",
    (1, 130): "Catalan",
    (1, 131): "Latin",
    (1, 132): "Quechua",
    (1, 133): "Guarani",
    (1, 134): "Aymara",
    (1, 135): "Tatar",
    (1, 136): "Uighur",
    (1, 137): "Dzongkha",
    (1, 138): "Javanese (Roman script)",
    (1, 139): "Sundanese (Roman script)",
    (1, 140): "Galician",
    (1, 141): "Afrikaans",
    (1, 142): "Breton",
    (1, 143): "Inuktitut",
    (1, 144): "Scottish Gaelic",
    (1, 145): "Manx Gaelic",
    (1, 146): "Irish Gaelic (with dot above)",
    (1, 147): "Tongan",
    (1, 148): "Greek (polytonic)",
    (1, 149): "Greenlandic",
    (1, 150): "Azerbaijani (Roman script)",
    # Windows platform
    # https://docs.microsoft.com/windows/desktop/intl/language-identifier-constants-and-strings
    (3, 0x0436): ("Afrikaans", "Zimbabwe", "af-ZW"),
    (3, 0x041C): ("Albanian", "Albania", "sq-AL"),
    (3, 0x0484): ("Alsatian", "France", "gsw-FR"),
    (3, 0x045E): ("Amharic", "Ethiopia", "am-ET"),
    (3, 0x1401): ("Arabic", "Algeria", "ar-DZ"),
    (3, 0x3C01): ("Arabic", "Bahrain", "ar-BH"),
    (3, 0x0C01): ("Arabic", "Egypt", "ar-EG"),
    (3, 0x0801): ("Arabic", "Iraq", "ar-IQ"),
    (3, 0x2C01): ("Arabic", "Jordan", "ar-JO"),
    (3, 0x3401): ("Arabic", "Kuwait", "ar-KW"),
    (3, 0x3001): ("Arabic", "Lebanon", "ar-LB"),
    (3, 0x1001): ("Arabic", "Libya", "ar-LY"),
    (3, 0x1801): ("Arabic", "Morocco", "ar-MA"),
    (3, 0x2001): ("Arabic", "Oman", "ar-OM"),
    (3, 0x4001): ("Arabic", "Qatar", "ar-QA"),
    (3, 0x0401): ("Arabic", "Saudi Arabia", "ar-SA"),
    (3, 0x2801): ("Arabic", "Syria", "ar-SY"),
    (3, 0x1C01): ("Arabic", "Tunisia", "ar-TN"),
    (3, 0x3801): ("Arabic", "U.A.E.", "ar-AE"),
    (3, 0x2401): ("Arabic", "Yemen", "ar-YE"),
    (3, 0x042B): ("Armenian", "Armenia", "hy-AM"),
    (3, 0x044D): ("Assamese", "India", "as-IN"),
    (3, 0x082C): ("Azerbaijani", "Azerbaijan, Cyrillic", "az-AZ"),
    (3, 0x042C): ("Azerbaijani", "Azerbaijan, Latin", "az-AZ"),
    (3, 0x0445): ("Bangla", "Bangladesh", "bn"),
    (3, 0x046D): ("Bashkir", "Russia", "ba-RU"),
    (3, 0x042D): ("Basque", "Basque", "Basque-Basque"),
    (3, 0x0423): ("Belarusian", "Belarus", "be-BY"),
    (3, 0x781A): ("Bosnian", "Neutral", "bs"),
    (3, 0x201A): ("Bosnian", "Bosnia and Herzegovina, Cyrillic", "bs-BA"),
    (3, 0x141A): ("Bosnian", "Bosnia and Herzegovina, Latin", "bs-BA"),
    (3, 0x047E): ("Breton", "France", "br-FR"),
    (3, 0x0402): ("Bulgarian", "Bulgaria", "bg-BG"),
    (3, 0x0492): ("Central Kurdish", "Iraq", "ku-IQ"),
    (3, 0x045C): ("Cherokee", "Cherokee", "chr-Cher"),
    (3, 0x0403): ("Catalan", "Spain", "ca-ES"),
    (3, 0x0C04): ("Chinese", "Hong Kong SAR, PRC", "zh-HK"),
    (3, 0x1404): ("Chinese", "Macao SAR", "zh-MO"),
    (3, 0x1004): ("Chinese", "Singapore", "zh-SG"),
    (3, 0x0004): ("Chinese", "Simplified", "zh-Hans"),
    (3, 0x7C04): ("Chinese", "Traditional", "zh-Hant"),
    (3, 0x0804): ("Chinese", "PRC", "zh-CN"),     # Deprecated but still widely used
    (3, 0x0404): ("Chinese", "Taiwan", "zh-TW"),  # Deprecated but still widely used
    (3, 0x0483): ("Corsican", "France", "co-FR"),
    (3, 0x001A): ("Croatian", "Neutral", "hr"),
    (3, 0x101A): ("Croatian", "Bosnia and Herzegovina, Latin", "hr-BA"),
    (3, 0x041A): ("Croatian", "Croatia", "hr-HR"),
    (3, 0x0405): ("Czech", "Czech Republic", "cs-CZ"),
    (3, 0x0406): ("Danish", "Denmark", "da-DK"),
    (3, 0x048C): ("Dari", "Afghanistan", "prs-AF"),
    (3, 0x0465): ("Divehi", "Maldives", "dv-MV"),
    (3, 0x0813): ("Dutch", "Belgium", "nl-BE"),
    (3, 0x0413): ("Dutch", "Netherlands", "nl-NL"),
    (3, 0x0C09): ("English", "Australia", "en-AU"),
    (3, 0x2809): ("English", "Belize", "en-BZ"),
    (3, 0x1009): ("English", "Canada", "en-CA"),
    (3, 0x2409): ("English", "Caribbean", "en"),
    (3, 0x4009): ("English", "India", "en-IN"),
    (3, 0x1809): ("English", "Ireland", "en-IE"),
    (3, 0x2009): ("English", "Jamaica", "en-JM"),
    (3, 0x4409): ("English", "Malaysia", "en-MY"),
    (3, 0x1409): ("English", "New Zealand", "en-NZ"),
    (3, 0x3409): ("English", "Philippines", "en-PH"),
    (3, 0x4809): ("English", "Singapore", "en-SG"),
    (3, 0x1c09): ("English", "South Africa", "en-ZA"),
    (3, 0x2C09): ("English", "Trinidad and Tobago", "en-TT"),
    (3, 0x0809): ("English", "United Kingdom", "en-GB"),
    (3, 0x0409): ("English", "United States", "en-US"),
    (3, 0x3009): ("English", "Zimbabwe", "en-ZW"),
    (3, 0x0425): ("Estonian", "Estonia", "et-EE"),
    (3, 0x0438): ("Faroese", "Faroe Islands", "fo-FO"),
    (3, 0x0464): ("Filipino", "Philippines", "fil-PH"),
    (3, 0x040B): ("Finnish", "Finland", "fi-FI"),
    (3, 0x080c): ("French", "Belgium", "fr-BE"),
    (3, 0x0C0C): ("French", "Canada", "fr-CA"),
    (3, 0x040c): ("French", "France", "fr-FR"),
    (3, 0x140C): ("French", "Luxembourg", "fr-LU"),
    (3, 0x180C): ("French", "Monaco", "fr-MC"),
    (3, 0x100C): ("French", "Switzerland", "fr-CH"),
    (3, 0x0462): ("Frisian", "Netherlands", "fy-NL"),
    (3, 0x0456): ("Galician", "Spain", "gl-ES"),
    (3, 0x0437): ("Georgian", "Georgia", "ka-GE"),
    (3, 0x0C07): ("German", "Austria", "de-AT"),
    (3, 0x0407): ("German", "Germany", "de-DE"),
    (3, 0x1407): ("German", "Liechtenstein", "de-LI"),
    (3, 0x1007): ("German", "Luxembourg", "de-LU"),
    (3, 0x0807): ("German", "Switzerland", "de-CH"),
    (3, 0x0408): ("Greek", "Greece", "el-GR"),
    (3, 0x046F): ("Greenlandic", "Greenland", "kl-GL"),
    (3, 0x0447): ("Gujarati", "India", "gu-IN"),
    (3, 0x0468): ("Hausa", "Nigeria", "ha-NG"),
    (3, 0x0475): ("Hawiian", "United States", "haw-US"),
    (3, 0x040D): ("Hebrew", "Israel", "he-IL"),
    (3, 0x0439): ("Hindi", "India", "hi-IN"),
    (3, 0x040E): ("Hungarian", "Hungary", "hu-HU"),
    (3, 0x040F): ("Icelandic", "Iceland", "is-IS"),
    (3, 0x0470): ("Igbo", "Nigeria", "ig-NG"),
    (3, 0x0421): ("Indonesian", "Indonesia", "id-ID"),
    (3, 0x085D): ("Inuktitut", "Canada", "iu-CA"),
    (3, 0x045D): ("Inuktitut", "Canada", "iu-CA"),
    (3, 0x083C): ("Irish", "Ireland", "ga-IE"),
    (3, 0x0434): ("isiXhosa", "South Africa", "xh-ZA"),
    (3, 0x0435): ("isiZulu", "South Africa", "zu-ZA"),
    (3, 0x0410): ("Italian", "Italy", "it-IT"),
    (3, 0x0810): ("Italian", "Switzerland", "it-CH"),
    (3, 0x0411): ("Japanese", "Japan", "ja-JP"),
    (3, 0x044B): ("Kannada", "India", "kn-IN"),
    (3, 0x043F): ("Kazakh", "Kazakhstan", "kk-KZ"),
    (3, 0x0453): ("Khmer", "Cambodia", "kh-KH"),
    (3, 0x0486): ("K'iche", "Guatemala", "qut-GT"),
    (3, 0x0487): ("Kinyarwanda", "Rwanda", "rw-RW"),
    (3, 0x0457): ("Konkani", "India", "kok-IN"),
    (3, 0x0412): ("Korean", "Korea", "ko-KR"),
    (3, 0x0440): ("Kyrgyz", "Kyrgyzstan", "ky-KG"),
    (3, 0x0454): ("Lao", "Lao PDR", "lo-LA"),
    (3, 0x0426): ("Latvian", "Latvia", "lv-LV"),
    (3, 0x0427): ("Lithuanian", "Lithuanian", "lt-LT"),
    (3, 0x082E): ("Lower Sorbian", "Germany", "dsb-DE"),
    (3, 0x046E): ("Luxembourgish", "Luxembourg", "lb-LU"),
    (3, 0x042F): ("Macedonian", "Macedonia (FYROM)", "mk-MK"),
    (3, 0x083E): ("Malay", "Brunei Darassalam", "ms-BN"),
    (3, 0x043e): ("Malay", "Malaysia", "ms-MY"),
    (3, 0x044C): ("Malayalam", "India", "ml-IN"),
    (3, 0x043A): ("Maltese", "Malta", "mt-MT"),
    (3, 0x0481): ("Maori", "New Zealand", "mi-NZ"),
    (3, 0x047A): ("Mapudungun", "Chile", "arn-CL"),
    (3, 0x044E): ("Marathi", "India", "mr-IN"),
    (3, 0x047C): ("Mohawk", "Canada", "moh-CA"),
    (3, 0x0450): ("Mongolian", "Mongolia, Cyrillic", "mn-MN"),
    (3, 0x0850): ("Mongolian", "Mongolia, Mong", "mn-MN"),
    (3, 0x0461): ("Nepali", "Nepal", "ne-NP"),
    (3, 0x0414): ("Norwegian", "Bokm\u00E5l, Norway", "no-NO"),
    (3, 0x0814): ("Norwegian", "Nynorsk, Norway", "no-NO"),
    (3, 0x0482): ("Occitan", "France", "oc-FR"),
    (3, 0x0448): ("Odia", "India", "or-IN"),
    (3, 0x0463): ("Pashto", "Afghanistan", "ps-AF"),
    (3, 0x0429): ("Persian", "Iran", "fa-IR"),
    (3, 0x0415): ("Polish", "Poland", "pl-PL"),
    (3, 0x0416): ("Portuguese", "Brazil", "pt-BR"),
    (3, 0x0816): ("Portuguese", "Portugal", "pt-PT"),
    (3, 0x0867): ("Pular", "Senegal", "ff-SN"),
    (3, 0x0446): ("Punjabi", "India, Gurmukhi script", "pa-IN"),
    (3, 0x0846): ("Punjabi", "Pakistan", "pa-PK"),
    (3, 0x046B): ("Quechua", "Bolivia", "quz-BO"),
    (3, 0x086B): ("Quechua", "Ecuador", "quz-EC"),
    (3, 0x0C6B): ("Quechua", "Peru", "quz-PE"),
    (3, 0x0418): ("Romanian", "Romania", "ro-RO"),
    (3, 0x0417): ("Romansh", "Switzerland", "rm-CH"),
    (3, 0x0419): ("Russian", "Russia", "ru-RU"),
    (3, 0x0485): ("Sakha", "Russia", "sah-RU"),
    (3, 0x243B): ("Sami", "Inari, Finland", "smn-FI"),
    (3, 0x103B): ("Sami", "Lule, Norway", "smj-NO"),
    (3, 0x143B): ("Sami", "Lule, Sweden", "smj-SE"),
    (3, 0x0C3B): ("Sami", "Northern, Finland", "se-FI"),
    (3, 0x043B): ("Sami", "Northern, Norway", "se-NO"),
    (3, 0x083B): ("Sami", "Northern, Sweden", "se-SE"),
    (3, 0x203B): ("Sami", "Skolt, Finland", "sms-FI"),
    (3, 0x183B): ("Sami", "Southern, Norway", "sma-NO"),
    (3, 0x1C3B): ("Sami", "Southern, Sweden", "sma-SE"),
    (3, 0x044F): ("Sanskrit", "India", "sa-IN"),
    (3, 0x7C1A): ("Serbian", "Neutral", "sr"),
    (3, 0x1C1A): ("Serbian", "Bosnia and Herzegovina, Cyrillic", "sr-BA"),
    (3, 0x181A): ("Serbian", "Bosnia and Herzegovina, Latin", "sr-BA"),
    (3, 0x0C1A): ("Serbian", "Serbia and Montenegro (former), Cyrillic", "sr-CS"),
    (3, 0x081A): ("Serbian", "Serbia and Montenegro (former), Latin", "sr-CS"),
    (3, 0x046C): ("Sesotho sa Leboa", "South Africa", "nso-ZA"),
    (3, 0x0832): ("Setswana / Tswana", "Botswana", "tn-BW"),
    (3, 0x0432): ("Setswana / Tswana", "South Africa", "tn-ZA"),
    (3, 0x0859): ("Sindhi", "Pakistan", "sd-PK"),
    (3, 0x045B): ("Sinhala", "Sri Lanka", "si-LK"),
    (3, 0x041B): ("Slovak", "Slovakia", "sk-SK"),
    (3, 0x0424): ("Slovenian", "Slovenia", "sl-SI"),
    (3, 0x2C0A): ("Spanish", "Argentina", "es-AR"),
    (3, 0x400A): ("Spanish", "Bolivia", "es-BO"),
    (3, 0x340A): ("Spanish", "Chile", "es-CL"),
    (3, 0x240A): ("Spanish", "Colombia", "es-CO"),
    (3, 0x140A): ("Spanish", "Costa Rica", "es-CR"),
    (3, 0x1C0A): ("Spanish", "Dominican Republic", "es-DO"),
    (3, 0x300A): ("Spanish", "Ecuador", "es-EC"),
    (3, 0x440A): ("Spanish", "El Salvador", "es-SV"),
    (3, 0x100A): ("Spanish", "Guatemala", "es-GT"),
    (3, 0x480A): ("Spanish", "Honduras", "es-HN"),
    (3, 0x080A): ("Spanish", "Mexico", "es-MX"),
    (3, 0x4C0A): ("Spanish", "Nicaragua", "es-NI"),
    (3, 0x180A): ("Spanish", "Panama", "es-PA"),
    (3, 0x3C0A): ("Spanish", "Paraguay", "es-PY"),
    (3, 0x280A): ("Spanish", "Peru", "es-PE"),
    (3, 0x500A): ("Spanish", "Puerto Rico", "es-PR"),
    (3, 0x0C0A): ("Spanish", "Spain, Modern Sort", "es-ES"),
    (3, 0x040A): ("Spanish", "Spain, Traditional Sort", "es-ES"),
    (3, 0x540A): ("Spanish", "United States", "es-US"),
    (3, 0x380A): ("Spanish", "Uruguay", "es-UY"),
    (3, 0x200A): ("Spanish", "Venezuela", "es-VE"),
    (3, 0x0441): ("Swahili", "Kenya", "sw-KE"),
    (3, 0x081D): ("Swedish", "Finland", "sv-FI"),
    (3, 0x041D): ("Swedish", "Sweden", "sv-SE"),
    (3, 0x045A): ("Syriac", "Syria", "syr-SY"),
    (3, 0x0428): ("Tajik", "Tajikistan, Cyrillic", "tg-TJ"),
    (3, 0x085F): ("Tamazight", "Algeria, Latin", "tzm-DZ"),
    (3, 0x0449): ("Tamil", "India", "ta-IN"),
    (3, 0x0849): ("Tamil", "Sri Lanka", "ta-LK"),
    (3, 0x0444): ("Tatar", "Russia", "tt-RU"),
    (3, 0x044A): ("Telugu", "India", "te-IN"),
    (3, 0x041E): ("Thai", "Thailand", "th-TH"),
    (3, 0x0451): ("Tibetan", "PRC", "bo-CN"),
    (3, 0x0873): ("Tigrinya", "Eritrea", "ti-ER"),
    (3, 0x0473): ("Tigrinya", "Ethiopia", "ti-ET"),
    (3, 0x041F): ("Turkish", "Turkey", "tr-TR"),
    (3, 0x0442): ("Turkmen", "Turkmenistan", "tk-TM"),
    (3, 0x0422): ("Ukrainian", "Ukraine", "uk-UA"),
    (3, 0x042E): ("Upper Sorbian", "Germany", "hsb-DE"),
    (3, 0x0420): ("Urdu", "Pakistan", "ur-PK"),
    (3, 0x0480): ("Uyghur", "PRC", "ug-CN"),
    (3, 0x0843): ("Uzbek", "Uzbekistan, Cyrillic", "uz-UZ"),
    (3, 0x0443): ("Uzbek", "Uzbekistan, Latin", "uz-UZ"),
    (3, 0x0803): ("Valencian", "Valencia", "ca-ES-Valencia"),
    (3, 0x042A): ("Vietnamese", "Vietnam", "vi-VN"),
    (3, 0x0452): ("Welsh", "United Kingdom", "cy-GB"),
    (3, 0x0488): ("Wolof", "Senegal", "wo-SN"),
    (3, 0x0478): ("Yi", "PRC", "ii-CN"),
    (3, 0x046A): ("Yoruba", "Nigeria", "yo-NG")
}

def list_font_file():
    font_file_list = []
    for _dir in FONT_DIR:
        for _ext in  FONT_FILE_EXT:
            font_file_list += glob.glob(_dir + "**/*" + _ext, recursive=True)
    return sorted(font_file_list)


class OpenType:
    def __init__(self, font_path: str):
        # File path and name
        self.font_file_path = font_path
        self.font_file_name = os.path.basename(font_path)
        self._font_file_ext = os.path.splitext(self.font_file_path)[1]

        with open(font_path, "rb") as f:
            self._raw_font = f.read()

        if self._font_file_ext in FONT_COLLECTION_FILE_EXT:
            ttc_tag, _, _, num_fonts = struct.unpack_from(
                ">IHHI", self._raw_font)
            if ttc_tag == _TTC_TAG:
                self.is_collection = True
                offset_list = list(struct.unpack_from(
                    ">" + "I" * num_fonts, self._raw_font, 12))  # 12 = size of ">IHHI"
            else:
                offset_list = []
                sys.stderr.write(self.font_file_path + ": Invalid OpenType collection!\n")
            self.fonts = [_OpenType(self.font_file_path, self._raw_font, offset)
                          for offset in offset_list]
        else:
            self.is_collection = False
            self.fonts = [_OpenType(self.font_file_path, self._raw_font)]


class _OpenType:
    def __init__(self, path: str, raw_font: bytes, offset: int=0):
        # Offset Table
        if (len(raw_font) < 12):
            self.is_valid = False
            sys.stderr.write(path + ": Invalid OpenType font!\n")
            return

        sfnt_version, _num_tables, _, _, _ = struct.unpack_from(
            ">IHHHH", raw_font, offset)
        if sfnt_version == _SFNT_VERSION_CFF:
            self.outline_type = "CFF"
        elif sfnt_version == _SFNT_VERSION_TRUETYPE:
            self.outline_type = "TrueType"
        else:
            self.is_valid = False
            sys.stderr.write(path + ": Invalid OpenType font!\n")
            return

        self.is_valid = True

        # Table record
        table_records = {}
        for i in range(_num_tables):
            table_tag, _, table_offset, table_length = struct.unpack_from(
                ">4sIII", raw_font, offset + 12 + 16 * i)  # 12, 16 = size of ">IHHHH", ">4sIII"
            table_records[table_tag] = {"offset": table_offset, "length": table_length}

        self._name = _Name(raw_font, table_records[b"name"]["offset"])

        self.copyright                  = self._join(self._name.copyright)
        self.family_name                = self._join(self._name.family_name)
        self.subfamily_name             = self._join(self._name.subfamily_name)
        self.full_name                  = self._join(self._name.full_name)
        self.version                    = self._join(self._name.version)
        self.postscript_name            = self._join(self._name.postscript_name)
        self.manufacturer               = self._join(self._name.manufacturer)
        self.designer                   = self._join(self._name.designer)
        self.desription                 = self._join(self._name.desription)
        self.typographic_family_name    = self._join(self._name.typographic_family_name)
        self.typographic_subfamily_name = self._join(self._name.typographic_subfamily_name)

    def _join(self, name_str_list: list):
        return ", ".join(set(name_str_list))


class _Name:
    def __init__(self, raw_font: bytes, offset: int):
        self._raw_font = raw_font
        self._offset = offset

        _, count, self._string_offset = self._unpack_from(">HHH")

        self._name_dict = {}
        for i in range(count):
            (platform_id, encoding_id, language_id, name_id,
             name_string_length, name_string_offset) = self._unpack_from(">HHHHHH", 6 + i * 12)
            name_record = self._name_record(platform_id, encoding_id, language_id,
                                            name_string_length, name_string_offset)
            if name_id not in self._name_dict:
                self._name_dict[name_id] = [name_record]
            else:
                self._name_dict[name_id].append(name_record)

        self.copyright                  = self._get(0)
        self.family_name                = self._get(1)
        self.subfamily_name             = self._get(2)
        self.full_name                  = self._get(4)
        self.version                    = self._get(5)
        self.postscript_name            = self._get(6)
        self.manufacturer               = self._get(8)
        self.designer                   = self._get(9)
        self.desription                 = self._get(10)
        self.typographic_family_name    = self._get(16)
        self.typographic_subfamily_name = self._get(17)


    def _unpack_from(self, format, offset: int=0):
        return struct.unpack_from(format, self._raw_font, self._offset + offset)

    def _name_record(self, platform_id, encoding_id, language_id, length, offset: int):
        real_offset = self._string_offset + offset
        encoding = (platform_id, encoding_id)
        language = (platform_id, language_id)
        encoding_name = ENCODING_ID_DICT.get(encoding, None)
        language_name = LANGUAGE_ID_DICT.get(language, None)
        name_str = self._unpack_from(">" + str(length) + "s", real_offset)[0]
        if encoding_name is not None:
            name_str = codecs.decode(name_str, encoding_name, errors="ignore")
        # DEBUG
        # return (language, language_name, encoding, encoding_name, name_str)
        return name_str

    def _get(self, key):
        return self._name_dict.get(key, [])


def _main():
    font_path_list = list_font_file()

    def if_empty(label, name):
        if name != "":
            print(label + name)

    def raw_str(string):
        return repr(string)[1:-2]

    for font_path in font_path_list:
        font = OpenType(font_path)
        print("Path:", font.font_file_path)
        for _font in font.fonts:
            print("\tFamily Name: " + _font.family_name)
            print("\t\tFull Name:    " + _font.full_name)
            print("\t\tPS Name:      " + _font.postscript_name)
            if_empty("\t\tManufacturer: ", _font.manufacturer)
            if_empty("\t\tDesigner:     ", _font.designer)
            if_empty("\t\tVersion:      ", _font.version)
            if_empty("\t\tCopyright:    ", raw_str(_font.copyright))
        print()

if __name__ == "__main__":
    _main()
