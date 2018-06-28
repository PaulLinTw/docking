from flask import Blueprint, render_template
from flask_login import login_required

blueprint = Blueprint(
    'products_blueprint',
    __name__,
    url_prefix='/products',
    template_folder='templates',
    static_folder='static'
)


@blueprint.route('/<template>')
@login_required
def route_template(template):
    return render_template(template + '.html')
