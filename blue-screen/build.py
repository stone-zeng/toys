# -*- coding: UTF-8 -*-

import argparse
import codecs
import json
import os

k_default_tex      = "xelatex"
k_default_options  = ""
k_default_convert  = "convert"
k_default_link     = "https://www.windows.com/stopcode"
k_default_settings = {
    "name": "blue",
    "color": "#0078D7",
    "emoji": ":(",
    "progress": 0
}

k_generated_file_prefix    = ".\\_"
k_generated_directory_name = "images"

def readFile(file_path):
    f = codecs.open(file_path, mode="r", encoding="UTF8")
    s = f.read()
    f.close()
    return s

def parseColorHex(color_str):
    return color_str[1:]

def parseConfig(config_file_path):
    s = readFile(config_file_path)
    json_data = json.loads(s)
    if "tex" not in json_data:
        json_data.update({"tex", k_default_tex})
    if "options" not in json_data:
        json_data.update({"options", k_default_options})
    if "convert" not in json_data:
        json_data.update({"convert", k_default_convert})
    if "items" not in json_data:
        json_data.update({"items", k_default_settings})
    return json_data

def replaceSettings(s, settings):
    s = s.replace("$EMOJI$", settings["emoji"])
    s = s.replace("$BGCOLOR$", parseColorHex(settings["color"]))
    s = s.replace("$PERCENT$", str(settings["progress"]))
    if "link" in settings:
        s = s.replace("$LINK$", settings["link"])
    else:
        s = s.replace("$LINK$", k_default_link)
    return s

def writeFile(file_path, str):
    f = codecs.open(file_path, mode="w", encoding="UTF8")
    f.write(str)
    f.close()

def runTeX(file_name, command, options):
    print("Compiling" + " " + file_name + " ...")
    os.system(command + " " + options + " " + file_name)

def generatePDF(file_path, setting_list, command, options):
    for setting in setting_list:
        file_name = k_generated_file_prefix + setting["name"] + ".tex"
        file_str = readFile(file_path)
        file_str = replaceSettings(file_str, setting)
        writeFile(file_name, file_str)
        runTeX(file_name, command, options)

def convertPDF(convert_exe, setting_list):
    for setting in setting_list:
        pdf_file_name = k_generated_file_prefix + setting["name"] + ".pdf"
        png_file_name = k_generated_file_prefix + setting["name"] + ".png"
        print("Generating" + " " + png_file_name + " ...")
        os.system(convert_exe + " " + pdf_file_name + " " + png_file_name)

def parseArgs():
    parser = argparse.ArgumentParser(description="Build Windows 10 blue screen pictures.")
    parser.add_argument("FILENAME")
    parser.add_argument("-c", "--config", help="choose JSON config file")
    parser.parse_args()

def cleanUp():
    os.mkdir(k_generated_directory_name)
    os.system("move " + k_generated_file_prefix + "*.png" + " " + k_generated_directory_name)
    os.system("del" + " " + k_generated_file_prefix + "*")

if __name__ == "__main__":
    # parseArgs()
    json = parseConfig("config.json")
    generatePDF("template.tex", json["items"], json["tex"], json["options"])
    convertPDF(json["convert"], json["items"])
    cleanUp()
