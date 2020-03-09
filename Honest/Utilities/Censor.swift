//
//  Censor.swift
//  Honest
//
//  Created by Ryan Schefske on 3/6/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import Foundation

class ProfanityFilter: NSObject {
    
    /* Words from https://www.freewebheaders.com/full-list-of-bad-words-banned-by-google/ */
    
    static func cleanUp(_ string: String) -> String {
        let dirtyWords = "\\b(2g1c|2 girls 1 cup|acrotomophilia|alabama hot pocket|anal|anilingus|apeshit|arsehole|ass|asshole|assmunch|auto erotic|autoerotic|babeland|baby batter|baby juice|ball gag|ball gravy|ball kicking|ball licking|ball sack|ball sucking|bangbros|bareback|barely legal|barenaked|bastard|bastardo|bastinado|bbw|bdsm|beaner|beaners|beaver cleaver|beaver lips|bestiality|big breasts|big knockers|big tits|bimbos|birdlock|bitch|bitches|black cock|blonde action|blonde on blonde action|blowjob|blow job|blow your load|blue waffle|blumpkin|bollocks|bondage|boner|booty call|brown showers|brunette action|bukkake|bulldyke|bullet vibe|bullshit|bung hole|bunghole|camel toe|camgirl|camslut|camwhore|carpet muncher|carpetmuncher|circlejerk|clit|clitoris|clover clamps|clusterfuck|cock|cocks|coprolagnia|coprophilia|cornhole|coon|coons|creampie|cum|cumming|cunnilingus|cunt|darkie|date rape|daterape|deep throat|deepthroat|dendrophilia|dick|dildo|dingleberry|dingleberries|dirty pillows|dirty sanchez|doggie style|doggiestyle|doggy style|doggystyle|dog style|dolcett|dominatrix|dommes|double dong|double penetration|dp action|dvda|ecchi|ejaculation|erotic|erotism|escort|eunuch|faggot|felch|fellatio|feltch|female squirting|femdom|figging|fingerbang|fingering|fisting|foot fetish|footjob|frotting|fuck|fuck buttons|fuckin|fucking|fucktards|fudge packer|fudgepacker|futanari|gang bang|gay sex|genitals|giant cock|girl on top|girls gone wild|goatcx|goatse|god damn|gokkun|golden shower|goo girl|goregasm|grope|group sex|g-spot|guro|hand job|handjob|hentai|homoerotic|hooker|hot chick|how to kill|how to murder|humping|incest|intercourse|jack off|jail bait|jailbait|jerk off|jigaboo|jiggaboo|jiggerboo|jizz|kike|kinbaku|kinkster|kinky|knobbing|leather restraint|leather straight jacket|lolita|male squirting|masturbate|menage a trois|milf|missionary position|motherfucker|muff diver|muffdiving|nambla|nawashi|negro|neonazi|nigga|nigger|nig nog|nimphomania|nsfw images|nude|nudity|nympho|nymphomania|octopussy|omorashi|one cup two girls|one guy one jar|orgasm|orgy|paedophile|paki|panties|panty|pedobear|pedophile|pegging|penis|phone sex|piece of shit|pissing|piss pig|pisspig|playboy|pleasure chest|pole smoker|ponyplay|poof|poon|poontang|punany|poop chute|poopchute|porn|porno|pornography|prince albert piercing|pthc|pubes|pussy|queaf|queef|quim|raghead|raging boner|rape|raping|rapist|rectum|reverse cowgirl|rimjob|rimming|rosy palm|rosy palm and her 5 sisters|rusty trombone|sadism|santorum|scat|schlong|scissoring|semen|sex|sexo|sexy|shaved beaver|shaved pussy|shemale|shibari|shit|shitblimp|shitty|shota|shrimping|skeet|slanteye|slut|s&m|smut|snatch|sodomize|sodomy|spic|splooge|splooge moose|spooge|spread legs|spunk|strap on|strapon|strappado|strip club|style doggy|suicide girls|sultry women|swastika|swinger|tainted love|threesome|throating|tied up|tight white|tongue in a|tosser|towelhead|tranny|tribadism|tub girl|tubgirl|twat|two girls one cup|upskirt|urethra play|urophilia|vagina|venus mound|vibrator|vorarephilia|voyeur|vulva|wetback|wet dream|white power|wrapping men|xx|xxx|yaoi|yellow showers|yiffy|zoophilia)\\b"
        
        func matches(for regex: String, in text: String) -> [String] {
            
            do {
                let regex = try NSRegularExpression(pattern: regex)
                let results = regex.matches(in: text,
                                            range: NSRange(text.startIndex..., in: text))
                return results.compactMap {
                    Range($0.range, in: text).map { String(text[$0]) }
                }
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return []
            }
        }
        
        let dirtyWordMatches = matches(for: dirtyWords, in: string)
        
        if dirtyWordMatches.count == 0 {
            return string
        } else {
            var newString = string
            
            dirtyWordMatches.forEach({ dirtyWord in
                let newWord = String(repeating: "*", count: dirtyWord.count)
                newString = newString.replacingOccurrences(of: dirtyWord, with: newWord, options: [.caseInsensitive])
            })
            
            return newString
        }
    }
}

