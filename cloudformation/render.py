from jinja2 import Environment, FileSystemLoader
env = Environment(loader=FileSystemLoader('.'))
template = env.get_template('compute-substack.cfn.yaml')
output_from_parsed_template = template.render()

# to save the results
with open("compute-substack.cfn.out.yaml", "w") as fh:
    fh.write(output_from_parsed_template)
