import argparse, json
p=argparse.ArgumentParser();p.add_argument('--input',required=True);p.add_argument('--output',required=True);a=p.parse_args()
d=json.load(open(a.input,'r',encoding='utf-8'));facts=[str(x).lower() for x in d.get('case_facts',[])]
rows=[]
for cond in d.get('candidate_conditions',[]):
 token=cond.lower().split()[0] if cond else ''
 support=[f for f in facts if token and token in f]
 oppose=[f for f in facts if 'denies' in f or 'no ' in f]
 rows.append({'condition':cond,'supporting_evidence':support,'opposing_evidence':oppose,'missing_evidence':['Key confirmatory and exclusionary findings not fully specified.']})
out={'evidence_map':rows,'limitations':['Heuristic mapper; does not assert clinical correctness.'],'human_review_required':True}
json.dump(out,open(a.output,'w',encoding='utf-8'),indent=2)
