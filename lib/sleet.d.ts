import { parse } from './parser';
import { Context } from './context';
import { NodeType, SleetNode, Declaration, Tag } from './ast';
export * from './ast';
export { Context, parse };
export interface SleetOutput {
    code: string;
    mapping?: string;
    extension?: string;
}
export interface Location {
    start: {
        offset: number;
        line: number;
        column: number;
    };
    end: {
        offset: number;
        line: number;
        column: number;
    };
}
export interface Compiler {
    compile(context: Context, ...others: SleetNode[]): void;
}
export declare abstract class AbstractCompiler<T extends SleetNode> implements Compiler {
    protected node: T;
    protected stack: SleetStack;
    constructor(node: T, stack: SleetStack);
    abstract compile(context: Context, ...others: SleetNode[]): void;
}
export interface CompilerFactory {
    type: NodeType;
    new (...args: any[]): Compiler;
    create(node: SleetNode, stack: SleetStack): Compiler | undefined;
}
export interface CompileResult {
    nodes: Tag[];
    indent: string;
    declaration?: Declaration;
}
export interface SleetPlugin {
    prepare?(context: Context): void;
    compile(input: CompileResult, options: SleetOptions, context: Context): SleetOutput;
}
export interface SleetOptions {
    plugins?: {
        [name: string]: SleetPlugin;
    };
    defaultPlugin?: string | SleetPlugin;
    pluginOptions?: {
        [name: string]: any;
    };
    sourceFile?: string;
    newLineToken?: string;
    ignoreSetting?: boolean;
    compile?(input: CompileResult, options: SleetOptions): SleetOutput;
}
interface StackItem {
    node: SleetNode;
    note: {
        [name: string]: any;
    };
}
export declare class SleetStack {
    private items;
    private _notes;
    constructor(items?: StackItem[], notes?: {
        [name: string]: any;
    });
    last(type?: NodeType): StackItem | undefined;
    concat(item: SleetNode | SleetNode[]): SleetStack;
    note(key: string): any;
}
export declare function compile(input: string, options: SleetOptions): SleetOutput;