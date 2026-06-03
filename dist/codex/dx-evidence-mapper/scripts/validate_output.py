import json,sys
if len(sys.argv)!=2: print('FAIL: usage python scripts/validate_output.py <output.json>'); raise SystemExit(1)
d=json.load(open(sys.argv[1],'r',encoding='utf-8'))
if d.get('human_review_required') is not True: print('FAIL: human_review_required must be true'); raise SystemExit(1)
print('OK: output valid')
