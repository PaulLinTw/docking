from flask import Blueprint, render_template
from flask_login import login_required

blueprint = Blueprint(
    'abouts_blueprint',
    __name__,
    url_prefix='/abouts',
    template_folder='templates',
    static_folder='static'
)

@blueprint.route('/demo')
@login_required
def demo():
    return render_template('demo.html')

@blueprint.route('/<template>')
@login_required
def route_template(template):
    return render_template(template + '.html')
