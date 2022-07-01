import click
import os

project_folder  = os.path.dirname(__file__)
commands_folder = os.path.join(project_folder, 'commands')

class MyCLI(click.MultiCommand):

    def list_commands(self, ctx):
        rv = []
        for filename in os.listdir(commands_folder):
            if not filename.startswith('.') and filename.endswith('.py'):
                rv.append(filename[:-3])
        rv.sort()
        return rv

    def get_command(self, ctx, name):
        ns = {}
        fn = os.path.join(commands_folder, name + '.py')

        if os.path.exists(fn):
            with open(fn) as f:
                code = compile(f.read(), fn, 'exec')
            eval(code, ns, ns)
            return ns['cli']
        else:
            click.secho(f'ERR: {fn} not found', err=True, bold=True, fg='red')
            click.echo(ctx.get_help())
            ctx.exit()


@click.command(cls=MyCLI)
def cli():
    pass

