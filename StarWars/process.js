var output = require('./output.json')

const kSubstructure = "key.substructure"
const kName = "key.name"
const kKind = "key.kind"
const struct = "source.lang.swift.decl.struct"
const clas = "source.lang.swift.decl.class"
const variable = "source.lang.swift.decl.var.instance"

const classes = output[kSubstructure]

    function process(item) {
        if (item[kKind] === struct || item[kKind] === clas) {
            let hasId = false
    
            item[kSubstructure].forEach(element => {
                if (element[kKind] === variable && element[kName] === "id") {
                    hasId = true
                }
            });        
    
            return {name: item[kName], hasId, children: item[kSubstructure].map(process).filter((a) => a)}
        }
    }
    
    let hasIds = []
    classes.map(process).forEach(o => {
        let title = o.name
    
        function buildUp(children) {
            children.forEach(oo => {
                title += `.${oo.name}`
    
                if (oo.hasId) {
                    hasIds.push(title)
                }
    
                buildUp(oo.children)
            })
        }
    
        buildUp(o.children)
    })
    
    let idExtension = ""
    hasIds.forEach(o => {
        idExtension += `
extension ${o}: Identifiable {
}
        `
    })
    
    const fs = require('fs')
    fs.writeFile('API+Ext.swift', "// Generated Code, do not touch\n" + idExtension, (err) => { 
        
    })