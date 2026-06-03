import argparse, json
def missing(v):return v is None or v=='' or v==[]
p=argparse.ArgumentParser();p.add_argument('--input',required=True);p.add_argument('--output',required=True);a=p.parse_args()
d=json.load(open(a.input,'r',encoding='utf-8'));h=d.get('history',{})
g={'timing':[],'location':[],'character':[],'severity':[],'associated_symptoms':[],'exposures':[],'medications':[],'reproductive_context':[]}
if missing(h.get('onset')): g['timing'].append('When did symptoms begin and how have they changed?')
if missing(h.get('location')): g['location'].append('Where is the symptom located and does it radiate?')
if missing(h.get('character')): g['character'].append('How would you describe the symptom quality?')
if missing(h.get('severity')): g['severity'].append('How severe is the symptom now and at worst?')
if missing(h.get('associated_symptoms')): g['associated_symptoms'].append('What associated symptoms are present or absent?')
if missing(h.get('exposures')): g['exposures'].append('Any recent exposures, travel, or sick contacts?')
if missing(d.get('patient',{}).get('medications')): g['medications'].append('What current medications or recent changes exist?')
if d.get('patient',{}).get('sex','').lower() in {'female','unknown'}: g['reproductive_context'].append('Could pregnancy or postpartum status be relevant?')
out={'question_groups':g,'limitations':['Template questions are not condition-specific clinical directives.'],'human_review_required':True}
json.dump(out,open(a.output,'w',encoding='utf-8'),indent=2)
