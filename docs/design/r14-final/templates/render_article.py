from pathlib import Path
import json,html,sys
from urllib.parse import urlparse
T=Path(__file__).resolve().parent

def safe_url(value):
 p=urlparse(value)
 if p.scheme=='https' or (not p.scheme and value.startswith('../assets/')):return html.escape(value,quote=True)
 raise ValueError('Unsupported asset/source URL')

def render(data,theme='light'):
 escape=lambda s:html.escape(str(s),quote=True)
 sections=[]
 for section in data['sections']:
  body=''.join('<p>'+escape(x)+'</p>' for x in section['paragraphs'])
  if section.get('steps'):body+='<ol>'+''.join('<li>'+escape(x)+'</li>' for x in section['steps'])+'</ol>'
  sections.append('<section><h3>'+escape(section['heading'])+'</h3>'+body+'</section>')
 sources=''.join('<p><a href="'+safe_url(x['url'])+'" rel="noreferrer">'+escape(x['label'])+'</a></p>' for x in data['sources']) or '<p>设计样本，正式发布前由编辑补充资料来源。</p>'
 values={k:escape(data.get(k,'')) for k in ['title','heroAlt','kicker','articleHeadline','intro','note']}
 values.update(theme='dark' if theme=='dark' else 'light',heroImageURL=safe_url(data['heroImageURL']),sectionsHTML=''.join(sections),sourcesHTML=sources,updatedText=escape('内容更新：'+data['updatedAt']))
 out=(T/'festival-article.template.html').read_text()
 for key,value in values.items():out=out.replace('{{'+key+'}}',value)
 if '{{' in out:raise ValueError('Unresolved template placeholder')
 return out
if __name__=='__main__':
 data=json.loads(Path(sys.argv[1]).read_text());output=Path(sys.argv[2]);output.write_text(render(data,sys.argv[3] if len(sys.argv)>3 else 'light'));print(output)
