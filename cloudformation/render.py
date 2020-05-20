from jinja2 import Environment, FileSystemLoader

env = Environment(loader=FileSystemLoader("."))
template = env.get_template("hit-substack.cfn.yaml")
output_from_parsed_template = template.render()

# to save the results
with open("hit-substack.rendered.cfn.yaml", "w") as fh:
    fh.write(output_from_parsed_template)
