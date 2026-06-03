import json,subprocess,sys
from pathlib import Path
r=Path(__file__).resolve().parents[1]; inp=r/'_self_test_input.json'; out=r/'_self_test_output.json'
s={'case_id':'sample-1','chief_complaint':'sample complaint','history':{'symptoms':['sample']},'candidate_conditions':['condition_a'],'case_facts':['fact_a'],'patient':{'sex':'female'}}
json.dump(s,open(inp,'w',encoding='utf-8'))
subprocess.run([sys.executable,str(r/'scripts'/'run.py'),'--input',str(inp),'--output',str(out)],check=True)
subprocess.run([sys.executable,str(r/'scripts'/'validate_output.py'),str(out)],check=True)
inp.unlink(missing_ok=True); out.unlink(missing_ok=True); print('OK: self test passed')
