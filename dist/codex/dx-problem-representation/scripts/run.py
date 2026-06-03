import argparse, json

p=argparse.ArgumentParser();p.add_argument('--input',required=True);p.add_argument('--output',required=True);a=p.parse_args()
d=json.load(open(a.input,'r',encoding='utf-8'))
age=d.get('patient',{}).get('age','unknown age');sex=d.get('patient',{}).get('sex','unknown sex')
cc=d.get('chief_complaint','unknown complaint');onset=d.get('history',{}).get('onset','unspecified time course')
pos=d.get('history',{}).get('symptoms',[]);neg=d.get('history',{}).get('key_negatives',[])
out={'problem_representation':f'{age} {sex} with {cc}, onset {onset}, positives={pos}, negatives={neg}.','risk_context':'Prototype summary for clinician-reviewed discussion only.','uncertainty':'Incomplete case detail may alter interpretation.','human_review_required':True}
json.dump(out,open(a.output,'w',encoding='utf-8'),indent=2)
