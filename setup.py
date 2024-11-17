import os
import subprocess
from setuptools import setup, find_packages
from setuptools.command.install import install

# Function to read the requirements.txt file
def parse_requirements(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    return [line.strip() for line in lines if line and not line.startswith('#')]

class CustomInstallCommand(install):
    """Customized setuptools install command to run a specific setup script."""
    user_options = install.user_options + [
        ('setup-type=', None, 'Specify the setup type: "local" or "cloud"')
    ]

    def initialize_options(self):
        install.initialize_options(self)
        self.setup_type = None

    def finalize_options(self):
        install.finalize_options(self)
        if self.setup_type not in ('local', 'cloud'):
            raise ValueError("Invalid setup type. Choose 'local' or 'cloud'.")

    def run(self):
        # Run the original install command
        install.run(self)

        # Determine which script to run based on setup_type
        script_name = {
            'local': 'local_setup.sh',
            'cloud': 'deploy_agent.sh'
        }.get(self.setup_type)

        if script_name:
            script_path = os.path.join('scripts', script_name)
            try:
                subprocess.check_call(['bash', script_path])
            except subprocess.CalledProcessError as e:
                print(f"Error occurred while running {script_name}: {e}")
                raise

setup(
    name='pr_cybr_agent',
    version='0.1.1',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    install_requires=parse_requirements('requirements.txt'),
    author='PR-CYBR',
    author_email='support@pr-cybr.com',
    description='PR-CYBR Agent',
    url='https://github.com/pr-cybr/',
    classifiers=[
        'Development Status :: 1 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
    ],
    python_requires='>=3.8',
    cmdclass={
        'install': CustomInstallCommand,
    },
)