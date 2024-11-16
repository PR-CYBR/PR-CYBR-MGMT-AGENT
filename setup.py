from setuptools import setup, find_packages

setup(
    name='pr_cybr_agent',
    version='0.1.0',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    install_requires=[
        # Add dependencies from requirements.txt
    ],
    author='PR-CYBR',
    author_email='support@pr-cybr.com',
    description='PR-CYBR Agent',
    url='https://github.com/pr-cybr/',
)
