//
//  VideoModel.swift
//  video player
//

import Foundation

var actualLang = "en"
var otherLang = "it"

class Subtitles {
    var times: [(Int,Int)]//mostrare il primo subtitle il cui tempo è maggiore del primo startTime
    var subtitles: [String]
    var lastFound: Int
    
    init(){
        self.times = [(Int,Int)]()
        self.subtitles = [String]()
        self.lastFound = 0
    }
    
    init(times: [(Int,Int)], subtitles: [String]) {
        self.times = times
        self.subtitles = subtitles
        self.lastFound = 0
    }
    
    func updateLastFound(lastFound: Int){
        self.lastFound = lastFound
    }
    
    func clear(){
        times = [(Int, Int)]()
        subtitles = [String]()
        lastFound = 0
    }
}

var subs = [String:Subtitles]()

//var times = [(Int,Int)]() //mostrare il primo subtitle il cui tempo è maggiore del primo startTime
//var subtitles = [String]()
var lastFound = 0
var textLabel = String()

func readSubtitle(name: String, language: String) -> String {
    var testo = ""
    if let pathName = subtitlePath(name: name, language: language) {
        let url = URL(fileURLWithPath: pathName)
        
        do {
            testo = try String(contentsOf: url, encoding: .utf8)
            subs[language] = extractInfo(subtitle: testo)
            return testo
        } catch  {
            print("file not found")
        }
        
    }
    return ""
}

func extractInfo(subtitle: String) -> Subtitles {
    let sub = Subtitles()
    var index = 0
    var subIndex = 0
    var lineCreated = false
    let lines = subtitle.components(separatedBy: "\n")
    for line in lines {
        if let num = Int(line) {
            index = num - 1
            subIndex = 0
        } else {
            if subIndex == 0 {
                let start = String(line.dropLast(17))
                let end = String(line.dropFirst(17))
                
                sub.times.append((Int(start.time()),Int(end.time())))
                subIndex += 1
            } else {
                if line != "" {
                    if lineCreated { // esiste già una linea in subtitle[index]
                        sub.subtitles[index] = "\(sub.subtitles[index])\r\(line)"
                    } else {
                        sub.subtitles.append(line)
                        lineCreated = true
                    }
                } else {
                    index += 1
                    lineCreated = false
                }
            }
        }
    }
    return sub
}

func videoName(name: String) -> String?{
    return Bundle.main.path(forResource: name, ofType: "mp4")
}

func subtitlePath(name: String, language: String) -> String?{
    let fullName = "\(name)_\(language)"
    return Bundle.main.path(forResource: fullName, ofType: "srt")
}

func searchSubtitle(time: Int, lang: String) -> String {
    var subtitle = ""
    let times = subs[actualLang]?.times ?? [(Int,Int)]()
    
    if let found = times.firstIndex(where: {($0.1 >= time) && ($0.0 <= time)}){
        subtitle = subs[lang]?.subtitles[found] ?? ""
        lastFound = found
    }
    return subtitle
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func time()->TimeInterval!{   //restituisce il tempo di riproduzione nella struct 'TimeInterval'?
        var withoutDec = self.components(separatedBy: ",")    //rimuove le frazioni di secondo n,xxx
        var time = withoutDec[0].components(separatedBy: ":")
        if let seconds = Double(time[2]) {
            if let minutes = Double(time[1]){
                if let hours = Double(time[0]){
                    return (hours * 3600 + seconds + (minutes * 60.0))
                }
            }
        }
        return nil
    }
    
}


