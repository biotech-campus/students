from cnvpytor.root import Root
import argparse


def cnvpytor(args):
    print("pytor file.")
    app = Root(args.pytor, create=True, max_cores=args.cpu)
    print("Read depth.")
    app.rd([args.bam])
    print(f"Calculate histograms {args.hists}")
    app.calculate_histograms(args.hists)
    print(f"Partition")
    app.partition(args.hists)
    calls = app.call(args.hists, print_calls=True)


def cnvkit(args):
    raise NotImplemented()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('tool', type=str, help='Tool name to launch')
    parser.add_argument('--bam', '-b', type=str, help='BAM filename', required=True)
    parser.add_argument('--pytor', '-n', type=str, help='CNVpytor filename', default='cache.pytor')
    parser.add_argument('--hists', nargs='+', help=' List of histogram bin sizes', default=[10000])
    parser.add_argument('--cpu', type=int, help='Max CPUs to use', default=4)
    args = parser.parse_args()

    if args.tool == 'cnvpytor':
        cnvpytor(args)
    elif args.tool == 'cnvkit':
        cnvkit(args)

if __name__ == '__main__':
    main()
    